open React
open RequestUtils
open Utils

type state = {
  sending: bool,
  success: option<string>,
  error: option<string>,
  email: string,
}

type action =
  | ResetPassword
  | SetEmail(string)
  | Failed(string)
  | Success(string)

@react.component
let make = () => {
  let (state, dispatch) = React.useReducer((state, action) =>
    switch action {
    | ResetPassword => {...state, sending: true, error: None}
    | Success(msg) => {...state, sending: false, success: Some(msg)}
    | SetEmail(email) => {...state, email: email}
    | Failed(error) => {...state, error: Some(error), sending: false}
    }
  , {sending: false, error: None, email: "", success: None})
  let resetPassword = email => {
    let payload = Js.Dict.empty()
    Js.Dict.set(payload, "email", Js.Json.string(email))
    let _ = dispatch(ResetPassword)
    requestJsonResponseToAction(
      ~headers=buildHeader(~verb=Post, ~body=payload, None),
      ~url=RestApi.requestResetPasswordPath,
      ~successAction=_ => dispatch(Success("Please check your email for a reset password link.")),
      ~failAction=json => dispatch(Failed(getResponseMsgFromJson(json))),
    )
  }
  <div className={"forgot-container " ++ (state.sending ? "loading" : "not-loading")}>
    <ForgotForm
      loading={state.sending || state.success |> Js.Option.isSome}
      setEmail={input => dispatch(SetEmail(input))}
      onSubmit={e => {
        ReactEvent.Form.preventDefault(e)
        Js.log(e)
        resetPassword(state.email) |> ignore
      }}
    />
    <Loading loading=state.sending />
    {switch state.success {
    | None => React.null
    | Some(msg) => <div className="text-info"> {string(msg)} </div>
    }}
    {switch state.error {
    | Some("")
    | None => React.null
    | Some(msg) => <div className="text-error"> {string(msg)} </div>
    }}
  </div>
}
