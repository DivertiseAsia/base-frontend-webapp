open React
open RequestUtils
open Utils
open ControlledFormGroup

type state = {
  data: Js.Dict.t<Js_json.t>,
  profile: Js.Dict.t<Js_json.t>,
  registerSuccess: WebData.t<bool>,
}
type action =
  | SubmitRequest(WebData.apiAction<bool>)
  | SetField(string, string)

@react.component
let make = (~defaultEmail: string="", ~defaultFirstName="", ~defaultLastName="") => {
  let (state, dispatch) = React.useReducer((state, action) =>
    switch action {
    | SubmitRequest(submitAction) => {
        ...state,
        registerSuccess: WebData.updateWebData(state.registerSuccess, submitAction),
      }
    | SetField(fieldName, fieldValue) => {
        switch fieldName {
        | "email" | "password" | "confirm_password" =>
          Js.Dict.set(state.data, fieldName, Js.Json.string(fieldValue))
        | fieldName => Js.Dict.set(state.profile, fieldName, Js.Json.string(fieldValue))
        }
        {...state, data: state.data, profile: state.profile}
      }
    }
  , {registerSuccess: RemoteData.NotAsked, data: Js.Dict.empty(), profile: Js.Dict.empty()})
  let submitData = data => {
    let payload = data
    Js.Dict.set(payload, "profile", state.profile |> Js.Json.object_)
    let _ = dispatch(SubmitRequest(WebData.RequestLoading))
    requestJsonResponseToAction(
      ~headers=buildHeader(~verb=Post, ~body=payload, None),
      ~url=Api.requestRegisterPath,
      ~successAction=_ => {
        dispatch(SubmitRequest(WebData.RequestSuccess(true)))
      },
      ~failAction=json =>
        dispatch(SubmitRequest(WebData.RequestError(getResponseMsgFromJson(json)))),
    )
  }
  let sending = switch state.registerSuccess {
  | RemoteData.Loading(_) => true
  | _ => false
  }
  let hasSuccess = switch state.registerSuccess {
  | RemoteData.Success(_) => true
  | _ => false
  }
  <div className={"register-container " ++ (sending ? "loading" : "not-loading")}>
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
        placeholder=TextLabel("John")
        validationStrategy=Empty
        warning=IntlTextWarning(Messages.Auth.warningEmailNotBlank)
        disabled={sending || hasSuccess}
        type_="text"
        onChange={e => dispatch(SetField("first_name", Utils.valueFromEvent(e)))}
        required=true
        defaultValue=defaultFirstName
      />
      <ControlledFormGroup
        placeholder=TextLabel("Smith")
        validationStrategy=Empty
        warning=IntlTextWarning(Messages.Auth.warningEmailNotBlank)
        disabled={sending || hasSuccess}
        type_="text"
        onChange={e => dispatch(SetField("last_name", Utils.valueFromEvent(e)))}
        required=true
        defaultValue=defaultLastName
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
      <ControlledFormGroup
        placeholder=IntlTextLabel(Messages.Auth.confirmPassword)
        validationStrategy=Empty
        warning=IntlTextWarning(Messages.Auth.warningPasswordNotBlank)
        disabled={sending || hasSuccess}
        type_="password"
        onChange={e => dispatch(SetField("confirm_password", Utils.valueFromEvent(e)))}
        required=true
      />
      <input id="terms" disabled={sending || hasSuccess} type_="checkbox" required=true />
      <label htmlFor="terms"> <IntlMessage message=Messages.Auth.termsAgree /> </label>
      <SubmitButton disabled=hasSuccess message=Messages.Auth.register />
    </form>
    {switch state.registerSuccess {
    | RemoteData.Loading(_) => <Loading />
    | RemoteData.NotAsked => React.null
    | RemoteData.Success(_) => <IntlMessage message=Messages.Auth.registerSuccess />
    | RemoteData.Failure(x) => <div className="text-error"> {string(x)} </div>
    }}
  </div>
}
