@react.component
let make = (~className: string) => {
  let randomHeight = () => {
    let random = Js.Math.random_int(100, 300)
    random->string_of_int
  }

  <>
    <div
      className="center-wrapper"
      style={ReactDOM.Style.make(~height={randomHeight() ++ "px"}, ~textAlign="center", ())}>
      {React.string("Card " ++ className)}
    </div>
  </>
}
