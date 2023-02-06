@react.component
let make = (
  ~className: string,
  ~title: string,
  ~authorName: array<'a>,
  ~publishYear: array<'a>,
  ~publishPlace: array<'a>,
) => {
  <>
    <div
      className
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
      <p> {React.array(authorName)} </p>
      <p> {React.array(publishYear)} </p>
      <p> {React.array(publishPlace)} </p>
    </div>
  </>
}
