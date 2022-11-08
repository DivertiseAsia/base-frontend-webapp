open React
open RequestUtils
open Utils
open ControlledFormGroup

type state = {
  data: Js.Dict.t<Js_json.t>,
  resetChangePassword: WebData.t<bool>,
}
type action =
  | SubmitRequest(WebData.apiAction<bool>)
  | SetField(string, string)

@react.component
let make = (~token: string) => {
  let (state, dispatch) = React.useReducer((state, action) =>
    switch action {
    | SubmitRequest(submitAction) => {
        ...state,
        resetChangePassword: WebData.updateWebData(state.resetChangePassword, submitAction),
      }
    | SetField(fieldName, fieldValue) => {
        Js.Dict.set(state.data, fieldName, Js.Json.string(fieldValue))
        {...state, data: state.data}
      }
    }
  , {resetChangePassword: RemoteData.NotAsked, data: Js.Dict.empty()})
  let submitData = data => {
    let payload = data
    let _ = dispatch(SubmitRequest(WebData.RequestLoading))
    requestJsonResponseToAction(
      ~headers=buildHeader(~verb=Post, ~body=payload, None),
      ~url=Api.requestResetPasswordConfirmPath,
      ~successAction=_ => {
        dispatch(SubmitRequest(WebData.RequestSuccess(true)))
      },
      ~failAction=json =>
        dispatch(SubmitRequest(WebData.RequestError(getResponseMsgFromJson(json)))),
    )
  }
  let sending = switch state.resetChangePassword {
  | RemoteData.Loading(_) => true
  | _ => false
  }
  let hasSuccess = switch state.resetChangePassword {
  | RemoteData.Success(_) => true
  | _ => false
  }
  <div className={"resetconfirm-container " ++ (sending ? "loading" : "not-loading")}>
    <form
      disabled=hasSuccess
      onSubmit={e => {
        ReactEvent.Form.preventDefault(e)
        if !hasSuccess {
          submitData(state.data) |> ignore
        }
      }}>
      <input type_="text" className="hidden" name="token" value=token />
      <ControlledFormGroup
        placeholder=IntlTextLabel(Messages.Auth.password)
        validationStrategy=Empty
        warning=IntlTextWarning(Messages.Auth.warningPasswordNotBlank)
        disabled={sending || hasSuccess}
        type_="password"
        onChange={e => dispatch(SetField("password", Utils.valueFromEvent(e)))}
        required=true
      />
      <ControlledFormGroup
        placeholder=IntlTextLabel(Messages.Auth.confirmPassword)
        validationStrategy=Empty
        warning=IntlTextWarning(Messages.Auth.warningPasswordNotBlank)
        disabled={sending || hasSuccess}
        type_="password"
        onChange={e => dispatch(SetField("confirm_password", Utils.valueFromEvent(e)))}
        required=true
      />
      <SubmitButton disabled=hasSuccess message=Messages.Auth.changePassword />
    </form>
    {switch state.resetChangePassword {
    | RemoteData.Loading(_) => <Loading />
    | RemoteData.NotAsked => React.null
    | RemoteData.Success(_) => <IntlMessage message=Messages.Auth.changePasswordSuccess />
    | RemoteData.Failure(x) => <div className="text-error"> {string(x)} </div>
    }}
  </div>
}
