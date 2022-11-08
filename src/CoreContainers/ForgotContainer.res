open React
open RequestUtils
open Utils
open ControlledFormGroup

type state = {
  data: Js.Dict.t<Js_json.t>,
  resetAction: WebData.t<bool>,
}
type action =
  | SubmitRequest(WebData.apiAction<bool>)
  | SetField(string, string)

@react.component
let make = (~defaultEmail: string="") => {
  let (state, dispatch) = React.useReducer((state, action) =>
    switch action {
    | SubmitRequest(submitAction) => {
        ...state,
        resetAction: WebData.updateWebData(state.resetAction, submitAction),
      }
    | SetField(fieldName, fieldValue) => {
        Js.Dict.set(state.data, fieldName, Js.Json.string(fieldValue))
        {...state, data: state.data}
      }
    }
  , {resetAction: RemoteData.NotAsked, data: Js.Dict.empty()})
  let submitData = data => {
    let payload = data
    let _ = dispatch(SubmitRequest(WebData.RequestLoading))
    requestJsonResponseToAction(
      ~headers=buildHeader(~verb=Post, ~body=payload, None),
      ~url=Api.requestResetPasswordPath,
      ~successAction=_ => {
        dispatch(SubmitRequest(WebData.RequestSuccess(true)))
      },
      ~failAction=json =>
        dispatch(SubmitRequest(WebData.RequestError(getResponseMsgFromJson(json)))),
    )
  }
  let sending = switch state.resetAction {
  | RemoteData.Loading(_) => true
  | _ => false
  }
  let hasSuccess = switch state.resetAction {
  | RemoteData.Success(_) => true
  | _ => false
  }
  <div className={"forgot-container " ++ (sending ? "loading" : "not-loading")}>
    <form
      disabled=hasSuccess
      onSubmit={e => {
        ReactEvent.Form.preventDefault(e)
        if !hasSuccess {
          submitData(state.data) |> ignore
        }
      }}>
      <ControlledFormGroup
        placeholder=IntlTextLabel(Messages.Auth.email)
        validationStrategy=Empty
        warning=IntlTextWarning(Messages.Auth.warningEmailNotBlank)
        disabled={sending || hasSuccess}
        type_="email"
        onChange={e => dispatch(SetField("email", Utils.valueFromEvent(e)))}
        required=true
        defaultValue=defaultEmail
      />
      <SubmitButton disabled=hasSuccess message=Messages.Auth.sendMeAReset />
    </form>
    {switch state.resetAction {
    | RemoteData.Loading(_) => <Loading />
    | RemoteData.NotAsked => React.null
    | RemoteData.Success(_) => <IntlMessage message=Messages.Auth.resetSuccess />
    | RemoteData.Failure(x) => <div className="text-error"> {string(x)} </div>
    }}
  </div>
}
