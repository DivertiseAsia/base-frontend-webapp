@react.component
let make = (~className: string, ~name: string, ~email: string) => {
  <>
    <div className>
      <p> {React.string(name)} </p>
      <p> {React.string(email)} </p>
    </div>
  </>
}