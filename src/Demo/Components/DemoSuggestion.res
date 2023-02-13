@react.component
let make = (~className: string, ~name: string) => {
  <span className contentEditable=false> {React.string(name)} </span>
}
