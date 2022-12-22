@react.component
let make = () => {
  <>
    <section
      style={ReactDOM.Style.make(
        ~display="flex",
        ~flexDirection="column",
        ~alignItems="center",
        ~width="100%",
        (),
      )}>
      <Card />
      <Card />
      <Card />
    </section>
  </>
}
