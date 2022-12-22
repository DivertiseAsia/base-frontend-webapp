@react.component
let make = () => {
  <>
    <div style={ReactDOM.Style.make(~border="1px solid black", ~minWidth="500px", ())}>
      {React.string("Card")}
    </div>
  </>
}
