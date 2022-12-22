@react.component
let make = () => {
  let (cardsList, setCardsList) = React.useState(_ => [])

  let createCardList = (cardsList) => {
    let numbers = Belt.Array.makeBy(15, i => i)
    let cardList = Belt.Array.map(numbers, number => {
      <Card
        key={Belt.Int.toString(number + Belt.Array.length(cardsList) + 1)}
        className={Belt.Int.toString(number + Belt.Array.length(cardsList) + 1)}
      />
    })
    cardList
  }

  React.useEffect0(() => {
    setCardsList(_ => createCardList(cardsList))
    None
  })

  <>
    <section
      style={ReactDOM.Style.make(
        ~display="flex",
        ~flexDirection="column",
        ~alignItems="center",
        ~width="100%",
        (),
      )}>
      {cardsList->React.array}
    </section>
  </>
}
