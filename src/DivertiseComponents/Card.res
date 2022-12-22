@react.component
let make = () => {
  let randomHeight = () => {
    let random = Js.Math.random_int(100, 300)
    random -> string_of_int
  }

  <>
    <div
      style={ReactDOM.Style.make(
        ~margin="10px 10px",
        ~padding="10px 10px",
        ~textAlign="center",
        ~border="1px solid black",
        ~width="50%",
        ~minWidth="150px",
        ~height={randomHeight() ++ "px"},
        (),
      )}>
      {React.string("Card")}
    </div>
  </>
}
