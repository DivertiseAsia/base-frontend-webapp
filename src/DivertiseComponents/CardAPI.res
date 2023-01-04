@react.component
let make = (
  ~title: string,
  ~author_name: array<'a>,
  ~publish_year: array<'a>,
  ~publish_place: array<'a>,
) => {
  <>
    <div
      style={ReactDOM.Style.make(
        ~margin="10px auto",
        ~padding="10px 10px",
        ~textAlign="center",
        ~border="1px solid black",
        ~width="50%",
        ~minWidth="150px",
        (),
      )}>
      <h2> {React.string(title)} </h2>
      <p> {React.array(author_name)} </p>
      <p> {React.array(publish_year)} </p>
      <p> {React.array(publish_place)} </p>
    </div>
  </>
}
