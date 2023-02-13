@react.component
let make = (~name: string, ~email: string) => {
  <>
    <p> {React.string(name)} </p>
    <p> {React.string(email)} </p>
  </>
}
