@module("axios") external axiosGet: string => Promise.t<'a> = "get"

let book_api = "https://openlibrary.org/search.json"

open Promise

@react.component
let make = () => {
  let (cardsList, setCardsList) = React.useState(_ => React.array([]))
  let (page, setPage) = React.useState(_ => 0)
  let (isLoading, setIsLoading) = React.useState(_ => false)
  let (isOutOfItems, setIsOutOfItems) = React.useState(_ => false)

  let _ =
    axiosGet(book_api ++ "?q=Tata" ++ "page=")
    ->then(data => data->Js.log->resolve)
    ->catch(err => {
      switch err {
      | JsError(obj) =>
        obj->Js.Exn.message->Belt.Option.getWithDefault("Must be some non-error value")->Js.log
      | _ => Js.log("Some unknown error")
      }
      resolve()
    })

  let onScrollDown = _ => {
    setIsLoading(_ => true)
    // let _ = Js.Global.setTimeout(() => {
    //   setCardsList(ele => {
    //     Belt.Array.concat(
    //       ele->React.Children.toArray,
    //       createCardList(cardsList, page, 15, 32)->React.Children.toArray,
    //     )->React.array
    //   })
    //   setIsLoading(_ => false)
    // }, 3000)
  }

  <InfiniteScroll
    isLoading
    isOutOfItems
    loadingComponent={React.string("Loading....")}
    onScrollDown
    onScrollPercent=0.8>
    cardsList
  </InfiniteScroll>
}
