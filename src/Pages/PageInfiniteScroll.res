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

  let (cardsList, setCardsList) = React.useState(_ => createCardList(React.array([])))
  let (isLoading, setIsLoading) = React.useState(_ => false)

  let onScrollDown = _ => {
    setIsLoading(_ => true)
    let _ = Js.Global.setTimeout(() => {
      setCardsList(ele => {
        Belt.Array.concat(
          ele->React.Children.toArray,
          createCardList(cardsList)->React.Children.toArray,
        )->React.array
      })
      setIsLoading(_ => false)
    }, 3000)
    // setCardsList(ele => {
    //   Belt.Array.concat(
    //     ele->React.Children.toArray,
    //     createCardList(cardsList)->React.Children.toArray,
    //   )->React.array
    // })
    // setIsLoading(_ => false)
  }

  <InfiniteScroll
    isLoading
    isOutOfItems=false
    loadingComponent={React.string("Loading....")}
    onScrollDown
    onScrollPercent=0.8>
    cardsList
  </InfiniteScroll>
}
