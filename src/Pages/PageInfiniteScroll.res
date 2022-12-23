@react.component
let make = () => {
  let (cardsList, setCardsList) = React.useState(_ => [])
  let (loading, setLoading) = React.useState(_ => false)
  let scrollContainerRef = React.useRef(Js.Nullable.null)

  let createCardList = cardsList => {
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

  React.useEffect(() => {
    if loading {
      ()
    }

    let (clientHeight, scrollHeight, scrollTop) = switch Js.Nullable.toOption(
      scrollContainerRef.current,
    ) {
    | None => (0., 0., 0.)
    | Some(element) => (
        Webapi.Dom.Element.clientHeight(element)->Belt.Int.toFloat,
        Webapi.Dom.Element.scrollHeight(element)->Belt.Int.toFloat,
        Webapi.Dom.Element.scrollTop(element),
      )
    }
    Js.logMany([clientHeight, scrollHeight, scrollTop])

    let reachedBottom = scrollHeight -. clientHeight *. 1.2 <= scrollTop +. 1.
    Js.log(reachedBottom)

    None
  })

  <div className="scroll-wrapper" style={ReactDOM.Style.make(~height="100vh", ())}>
    <section
      id="scroll-container"
      ref={ReactDOM.Ref.domRef(scrollContainerRef)}
      style={ReactDOM.Style.make(
        ~display="flex",
        ~flexDirection="column",
        ~alignItems="center",
        ~width="100%",
        ~height="100%",
        ~overflow="auto",
        ~position="relative",
        ~backgroundColor="coral",
        (),
      )}>
      {cardsList->React.array}
    </section>
  </div>
}
