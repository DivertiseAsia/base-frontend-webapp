open ReactIntl

type validationStrategy =
  | Empty
  | Func(string => bool)

type warning =
  | TextWarning(string)
  | IntlTextWarning(ReactIntl.message)
  | TextWarningWithIcon(string, string)
  | IntlTextWarningWithIcon(ReactIntl.message, string)

type label = TextLabel(string) | IntlTextLabel(ReactIntl.message)

@react.component
let make = (
  ~id: option<string>=?,
  ~warning: option<warning>=?,
  ~label: option<label>=?,
  ~validationStrategy: option<validationStrategy>=?,
  ~className: option<string>=?,
  ~inputClassName: option<string>=?,
  ~iconClassName: option<string>=?,
  ~value: option<string>=?,
  ~defaultValue: option<string>=?,
  ~disabled: option<bool>=?,
  ~type_: string,
  ~onChange=?,
  ~onBlur=?,
  ~required=?,
  ~list=?,
  ~autoComplete=?,
  ~placeholder: option<label>=?,
) => {
  let intl = ReactIntl.useIntl()
  let (hasError, setHasError) = React.useState(() => false)
  let warning = switch (hasError, warning) {
  | (_, None) | (false, _) => None
  | (true, Some(TextWarning(warningString))) => Some(React.string(warningString))
  | (true, Some(IntlTextWarning(warningMessage))) => Some(<IntlMessage message=warningMessage />)
  | (true, Some(IntlTextWarningWithIcon(warningMessage, iconClass))) =>
    Some(
      <p className="warning-text-with-icon">
        <span className="icon-container"> <i className=iconClass /> </span>
        <IntlMessage message=warningMessage />
      </p>,
    )
  | (true, Some(TextWarningWithIcon(warningString, iconClass))) =>
    Some(
      <p className="warning-text-with-icon">
        <span className="icon-container"> <i className=iconClass /> </span>
        {React.string(warningString)}
      </p>,
    )
  }
  <FormGroup ?className ?iconClassName ?warning>
    {switch label {
    | None => React.null
    | Some(TextLabel(text)) =>
      let htmlFor = id
      <label className="active" ?htmlFor> {React.string(text)} </label>
    | Some(IntlTextLabel(message)) =>
      let htmlFor = id
      <label className="active" ?htmlFor> <IntlMessage message /> </label>
    }}
    <TextInput
      className={"form-control " ++ Js.Option.getWithDefault("", inputClassName)}
      ?id
      ?value
      ?defaultValue
      ?disabled
      ?onChange
      ?required
      ?list
      ?autoComplete
      placeholder={switch placeholder {
      | None => ""
      | Some(TextLabel(x)) => x
      | Some(IntlTextLabel(message)) => intl->Intl.formatMessage(message)
      }}
      type_
      onBlur={e => {
        let value = ReactEvent.Focus.target(e)["value"]
        let hasError = switch validationStrategy {
        | None => false
        | Some(Empty) => value == ""
        | Some(Func(x)) => x(value)
        }
        setHasError(_ => hasError)
        switch onBlur {
        | None => ()
        | Some(f) => f(e)
        }
      }}
    />
  </FormGroup>
}
