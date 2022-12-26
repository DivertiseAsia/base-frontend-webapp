@react.component
let make = () => {
  let (cardsList, setCardsList) = React.useState(_ => React.array([]))
  let (isLoading, setIsLoading) = React.useState(_ => false)
  let (isShown, setIsShown) = React.useState(_ => false)
  let scrollContainerRef = React.useRef(Js.Nullable.null)

  let createCardList = () => {
    let numbers = Belt.Array.makeBy(15, i => i)
    let cardList = {
      Belt.Array.map(numbers, number => {
        <Card
          key={Belt.Int.toString(number + Belt.Array.length(React.Children.toArray(cardsList)) + 1)}
          className={Belt.Int.toString(
            number + Belt.Array.length(React.Children.toArray(cardsList)) + 1,
          )}
        />
      })->React.array
    }
    Js.log(cardList)
    cardList
  }

  React.useEffect0(() => {
    setCardsList(_ => createCardList())
    None
  })

  React.useEffect(() => {
    if isLoading {
      ()
    }

    let handleScroll = _e => {
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

      if reachedBottom {
        setIsLoading(_ => true)
        setIsShown(_ => false)
        let timer = Js.Global.setTimeout(() => setIsShown(_ => true), 2000)
        let loadedItem = createCardList()
        Js.Global.clearTimeout(timer)
        setCardsList(ele => {
          Belt.Array.concat(
            ele->React.Children.toArray,
            (isShown ? loadedItem : React.null)->React.Children.toArray,
          )->React.array
        })
        setIsLoading(_ => false)
      }
    }

    let _ = switch Js.Nullable.toOption(scrollContainerRef.current) {
    | None => ()
    | Some(element) => Webapi.Dom.Element.addEventListener(element, "scroll", handleScroll)
    }

    Some(
      () => {
        let _ = switch Js.Nullable.toOption(scrollContainerRef.current) {
        | None => ()
        | Some(element) => Webapi.Dom.Element.removeEventListener(element, "scroll", handleScroll)
        }
      },
    )
  })

  React.useEffect1(() => {
    let timer = Js.Global.setTimeout(() => setIsShown(_ => true), 2000)

    Some(_ => Js.Global.clearTimeout(timer))
  }, [cardsList])

  <div className="scroll-wrapper" style={ReactDOM.Style.make(~height="100vh", ())}>
    <section
      id="scroll-container"
      ref={ReactDOM.Ref.domRef(scrollContainerRef)}
      style={ReactDOM.Style.make(
        ~width="100%",
        ~height="100%",
        ~overflow="auto",
        ~position="relative",
        (),
      )}>
      {isShown ? cardsList : React.null}
    </section>
  </div>
}
