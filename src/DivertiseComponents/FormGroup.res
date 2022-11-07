@react.component
let make = (
  ~className: option<string>=?,
  ~iconClassName: option<string>=?,
  ~warning: option<React.element>=?,
  ~children,
) => {
  <div className={"form-group " ++ Js.Option.getWithDefault("", className)}>
    <div>
      {switch iconClassName {
      | None | Some("") => React.null
      | Some(x) => <span className="icon-container"> <i className=x /> </span>
      }}
      children
    </div>
    <div className="warning-text">
      {switch warning {
      | None => React.null
      | Some(x) => x
      }}
    </div>
  </div>
}
