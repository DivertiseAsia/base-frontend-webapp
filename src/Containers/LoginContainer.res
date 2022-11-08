open React
open RequestUtils
open Utils
open ControlledFormGroup

type state = {
  data: Js.Dict.t<Js_json.t>,
  loginSuccess: WebData.t<string>,
}
type action =
  | SubmitRequest(WebData.apiAction<string>)
  | SetField(string, string)

@react.component
let make = (~defaultEmail: string="") => {
  let setToken = User.Context.getSetToken()
  let (state, dispatch) = React.useReducer((state, action) =>
    switch action {
    | SubmitRequest(submitAction) => {
        ...state,
        loginSuccess: WebData.updateWebData(state.loginSuccess, submitAction),
      }
    | SetField(fieldName, fieldValue) => {
        Js.Dict.set(state.data, fieldName, Js.Json.string(fieldValue))
        {...state, data: state.data}
      }
    }
  , {loginSuccess: RemoteData.NotAsked, data: Js.Dict.empty()})
  let submitData = data => {
    let payload = data
    let _ = dispatch(SubmitRequest(WebData.RequestLoading))
    requestJsonResponseToAction(
      ~headers=buildHeader(~verb=Post, ~body=payload, None),
      ~url=Api.requestLoginPath,
      ~successAction=json => {
        let token = json |> Json.Decode.field("token", Json.Decode.string)
        dispatch(SubmitRequest(WebData.RequestSuccess(token)))
        setToken(token)
      },
      ~failAction=json =>
        dispatch(SubmitRequest(WebData.RequestError(getResponseMsgFromJson(json)))),
    )
  }
  let sending = switch state.loginSuccess {
  | RemoteData.Loading(_) => true
  | _ => false
  }
  let hasSuccess = switch state.loginSuccess {
  | RemoteData.Success(_) => true
  | _ => false
  }
  <div className={"login-container " ++ (sending ? "loading" : "not-loading")}>
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
      <ControlledFormGroup
        placeholder=IntlTextLabel(Messages.Auth.password)
        validationStrategy=Empty
        warning=IntlTextWarning(Messages.Auth.warningPasswordNotBlank)
        disabled={sending || hasSuccess}
        type_="password"
        onChange={e => dispatch(SetField("password", Utils.valueFromEvent(e)))}
        required=true
      />
      <SubmitButton disabled=hasSuccess message=Messages.Auth.login />
    </form>
    {switch state.loginSuccess {
    | RemoteData.Loading(_) => <Loading />
    | RemoteData.NotAsked => React.null
    | RemoteData.Success(_) => <IntlMessage message=Messages.Auth.loginSuccess />
    | RemoteData.Failure(x) => <div className="text-error"> {string(x)} </div>
    }}
  </div>
}
