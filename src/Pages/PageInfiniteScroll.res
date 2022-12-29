@react.component
let make = () => {
  let createCardList = list => {
    let numbers = Belt.Array.makeBy(15, i => i)
    let cardList = {
      Belt.Array.map(numbers, number => {
        <Card
          key={Belt.Int.toString(number + Belt.Array.length(React.Children.toArray(list)) + 1)}
          className={Belt.Int.toString(
            number + Belt.Array.length(React.Children.toArray(list)) + 1,
          )}
        />
      })->React.array
    }
    Js.log(cardList)
    cardList
  }

  let (cardsList, setCardsList) = React.useState(_ => createCardList(cardsList))
  let (isLoading, setIsLoading) = React.useState(_ => false)

  let onScrollDown = _ => {
    setIsLoading(_ => true)
    Js.Global.setTimeout(() => {
      setCardsList(ele => {
        Belt.Array.concat(
          ele->React.Children.toArray,
          (isShown ? createCardList() : React.null)->React.Children.toArray,
        )->React.array
      })
      setIsLoading(_ => false)
    }, 3000)
  }

  <InfiniteScroll
    isLoading
    loadingComponent={React.string("Loading....")}
    isOutOfItems=false
    onScrollDown
    onScrollPercent=0.8>
    cardsList
  </InfiniteScroll>
}
