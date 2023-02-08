@react.component
let make = (~className: string, ~name: string) => {
  <>
    <div className>
      <span contentEditable=false> {React.string(name)} </span>
    </div>
  </>
}