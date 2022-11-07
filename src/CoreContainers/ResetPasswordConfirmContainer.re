open React;
open RequestUtils;
open Utils;

type state = {
  sending: bool,
  success: option(string),
  error: option(string),
  password: string,
  passwordConfirm: string,
};

type action =
  | SendingAction
  | SetPassword(string)
  | SetPasswordConfirm(string)
  | Failed(string)
  | Success(string);

[@react.component]
let make = (~token:string) => {
  let (state, dispatch) = React.useReducer(
    (state, action) =>
      switch (action) {
      | SendingAction => {...state, sending: true, error: None}
      | Success(msg) => {...state, sending: false, success: Some(msg)}
      | SetPassword(password) => {...state, password}
      | SetPasswordConfirm(passwordConfirm) => {...state, passwordConfirm}
      | Failed(error) => {...state, error: Some(error), sending: false}
      },
    {sending: false, error: None, password: "", passwordConfirm: "", success: None}
  );
  let changePassword = (password,passwordConfirm) => {
    if (password !== passwordConfirm) {
      dispatch(Failed("Passwords must match"))
    } else {
      let payload = Js.Dict.empty();
      Js.Dict.set(payload, "password", Js.Json.string(password));
      Js.Dict.set(payload, "token", Js.Json.string(token));
      let _ = dispatch(SendingAction);
      requestJsonResponseToAction(
        ~headers=buildHeader(~verb=Post, ~body=payload, None),
        ~url=RestApi.requestResetPasswordConfirmPath ,
        ~successAction=_ => dispatch(Success("Your password has been changed. Please login")),
        ~failAction=json => dispatch(Failed(getResponseMsgFromJson(json))),
      ) |> ignore;
    }
  };
  <div className={"reset-confirm-container " ++ (state.sending ? "loading" : "not-loading")}>
    <ResetPasswordConfirmForm
      token
      loading={state.sending || state.success |> Js.Option.isSome}
      setPassword={input => dispatch(SetPassword(input))}
      setPasswordConfirm={input => dispatch(SetPasswordConfirm(input))}
      onSubmit={
        e => {
          ReactEvent.Form.preventDefault(e);
          changePassword(state.password, state.passwordConfirm) |> ignore
        }
      }
    />
    <Loading loading=state.sending />
    {
      switch (state.success) {
      | None => React.null
      | Some(msg) => <div className="text-info"> {string(msg)} </div>
      }
    }
    {
      switch (state.error) {
      | Some("")
      | None => React.null
      | Some(msg) => <div className="text-error"> {string(msg)} </div>
      }
    }
  </div>
};
