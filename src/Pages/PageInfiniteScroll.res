@react.component
let make = () => {
  let (cardsList, setCardsList) = React.useState(_ => React.array([]))
  let (page, setPage) = React.useState(_ => 0)
  let (isLoading, setIsLoading) = React.useState(_ => false)
  let (isOutOfItems, setIsOutOfItems) = React.useState(_ => false)

  let createCardList = (list: React.element, page: int, loadPerPage: int, total: int) => {
    let remainder = total - page * loadPerPage
    // if there are no more items to load
    if remainder < 0 {
      setIsOutOfItems(_ => true)
      React.array([])
    } else if remainder < loadPerPage {
      // if there are less items to load than the loadPerPage
      let numbers = Belt.Array.makeBy(remainder, i => i)
      let cardList = {
        Belt.Array.map(numbers, number => {
          <DemoCard
            key={Belt.Int.toString(number + Belt.Array.length(React.Children.toArray(list)) + 1)}
            className={Belt.Int.toString(
              number + Belt.Array.length(React.Children.toArray(list)) + 1,
            )}
          />
        })->React.array
      }
      setIsOutOfItems(_ => true)
      setPage(_ => page + 1)
      cardList
    } else {
      let numbers = Belt.Array.makeBy(loadPerPage, i => i)
      let cardList = {
        Belt.Array.map(numbers, number => {
          <DemoCard
            key={Belt.Int.toString(number + Belt.Array.length(React.Children.toArray(list)) + 1)}
            className={Belt.Int.toString(
              number + Belt.Array.length(React.Children.toArray(list)) + 1,
            )}
          />
        })->React.array
      }
      setPage(_ => page + 1)
      cardList
    }
  }

  let loadMoreItems = _ => {
    setIsLoading(_ => true)
    let _ = Js.Global.setTimeout(() => {
      setCardsList(ele => {
        Belt.Array.concat(
          ele->React.Children.toArray,
          createCardList(cardsList, page, 30, 100)->React.Children.toArray,
        )->React.array
      })
      setIsLoading(_ => false)
    }, 3000)
  }

  React.useEffect0(() => {
    setCardsList(_ => createCardList(cardsList, page, 30, 100))
    None
  })

  // * : This div is needed to collect the height of the screen (clientHeight)
  <div className="scroll-wrapper" style={ReactDOM.Style.make(~height="100vh", ())}>
    <InfiniteScroll
      isLoading
      isOutOfItems
      loadingComponent={React.string("Loading....")}
      endingComponent={React.string("...End...")}
      loadMoreItems
      onScrollPercent=0.8>
      cardsList
    </InfiniteScroll>
  </div>
}
