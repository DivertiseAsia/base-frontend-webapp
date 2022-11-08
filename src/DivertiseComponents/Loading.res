@react.component
let make = (~loading: bool=true) => {
  loading ? <IntlMessage message=Messages.Global.loading /> : React.null
}
