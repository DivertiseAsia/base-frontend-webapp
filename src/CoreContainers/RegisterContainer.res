open React
open RequestUtils
open Utils
open ControlledFormGroup

type state = {
  sending: bool,
  hasSuccess: bool,
  submitError: option<string>,
  data: Js.Dict.t<Js_json.t>,
}
type action =
  | Submit
  | SetField(string, string)
  | SubmitFailed(string)
  | SubmitSuccess

@react.component
let make = () => {
  let (state, dispatch) = React.useReducer((state, action) =>
    switch action {
    | Submit => {...state, sending: true, submitError: None}
    | SubmitSuccess => {...state, sending: false, hasSuccess: true}
    | SetField(fieldName, fieldValue) => {
        let _ = Js.Dict.set(state.data, fieldName, Js.Json.string(fieldValue))
        let _ = Js.log(state.data)
        {...state, data: state.data}
      }
    | SubmitFailed(error) => {...state, submitError: Some(error), sending: false}
    }
  , {sending: false, submitError: None, data: Js.Dict.empty(), hasSuccess: false})
  let submitData = data => {
    let payload = data
    let _ = dispatch(Submit)
    requestJsonResponseToAction(
      ~headers=buildHeader(~verb=Post, ~body=payload, None),
      ~url=RestApi.requestRegisterPath,
      ~successAction=_ => {
        dispatch(SubmitSuccess)
      },
      ~failAction=json => dispatch(SubmitFailed(getResponseMsgFromJson(json))),
    )
  }
  <div className={"register-container " ++ (state.sending ? "loading" : "not-loading")}>
    <form
      onSubmit={e => {
        ReactEvent.Form.preventDefault(e)
        Js.log(state.data)
        submitData(state.data) |> ignore
      }}>
      <ControlledFormGroup
        placeholder="Email"
        validationStrategy=Empty
        warning=TextWarning("Email must not be blank")
        disabled={state.sending || state.hasSuccess}
        type_="email"
        onChange={e => dispatch(SetField("email", Utils.valueFromEvent(e)))}
        required=true
      />
      <ControlledFormGroup
        placeholder="Password"
        validationStrategy=Empty
        warning=TextWarning("Password must not be blank")
        disabled={state.sending || state.hasSuccess}
        type_="password"
        onChange={e => dispatch(SetField("password", Utils.valueFromEvent(e)))}
        required=true
      />
      <ControlledFormGroup
        placeholder="Password Confirmation"
        validationStrategy=Empty
        warning=TextWarning("Password must not be blank")
        disabled={state.sending || state.hasSuccess}
        type_="password"
        onChange={e => dispatch(SetField("confirm_password", Utils.valueFromEvent(e)))}
        required=true
      />
      <div className="container">
        <div className="row mt-3">
          <div className="col-2 text-center">
            <input
              disabled={state.sending || state.hasSuccess}
              onChange={e =>
                dispatch(SetField("checkbox", Utils.boolFromCheckbox(e) |> string_of_bool))}
              type_="checkbox"
              required=true
            />
          </div>
          <div className="col-10">
            <p>
              {string("Lorem lpsum is simple dummy text of the printing and typesetting industry.")}
            </p>
          </div>
        </div>
      </div>
      <input
        type_="submit" className="btn btn-filled btn-filled-auth-page btn-default mb-4" value="Next"
      />
    </form>
    {state.sending === true ? <Loading /> : React.null}
    {state.hasSuccess
      ? <div className="text-info">
          {string("Registration complete. You will need to be approved to login.")}
        </div>
      : null}
    {switch state.submitError {
    | Some("")
    | None => null
    | Some(x) => <div className="text-error"> {string(x)} </div>
    }}
  </div>
}
