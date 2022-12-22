@react.component
let make = () => {
  let createCardList = () => {
    let numbers = Belt.Array.makeBy(15, (i) => i)
    let cardList = Belt.Array.map(numbers, (number) => {
      {<Card key={Belt.Int.toString(number)} />}
    })
    cardList
  }

  <>
    <section
      style={ReactDOM.Style.make(
        ~display="flex",
        ~flexDirection="column",
        ~alignItems="center",
        ~width="100%",
        (),
      )}>
      {createCardList()->React.array}
    </section>
  </>
}
