open ReactIntl

@react.component
let make = (
  ~className: string="",
  ~disabled: bool=false,
  ~values: option<{..}>=?,
  ~message: ReactIntl.message,
) => {
  let intl = ReactIntl.useIntl()

  let value = switch values {
  | None => intl->Intl.formatMessage(message)
  | Some(values) => intl->Intl.formatMessageWithValues(message, values)
  }

  <input disabled type_="submit" className value />
}
