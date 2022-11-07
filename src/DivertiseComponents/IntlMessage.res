open ReactIntl

@react.component
let make = (~message: ReactIntl.message, ~values: option<{..}>=?) => {
  let intl = ReactIntl.useIntl()

  {
    switch values {
    | None => intl->Intl.formatMessage(message)
    | Some(values) => intl->Intl.formatMessageWithValues(message, values)
    }->React.string
  }
}
