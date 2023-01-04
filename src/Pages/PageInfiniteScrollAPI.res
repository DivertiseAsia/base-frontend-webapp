type params = {
  q: string,
  page: int,
}

type fullParams = {params: params}

@module("axios") external axiosGet: (string, fullParams) => Promise.t<'a> = "get"

let book_api = "https://openlibrary.org/search.json"

open Promise

@react.component
let make = () => {
  let (books, setBooks) = React.useState(_ => [])
  let (query, setQuery) = React.useState(_ => "")
  let (page, setPage) = React.useState(_ => 1)
  let (numFound, setNumFound) = React.useState(_ => 0)
  let (isLoading, setIsLoading) = React.useState(_ => false)
  let (isError, setIsError) = React.useState(_ => false)
  let (isOutOfItems, setIsOutOfItems) = React.useState(_ => false)

  let getData = () => {
    let timeOut = Js.Global.setTimeout(() => {
      let _ =
        axiosGet(
          book_api,
          {
            params: {
              q: query,
              page: page,
            },
          },
        )
        ->then(data => {
          setIsLoading(_ => false)
          data["data"]["docs"]->Belt.Array.length > 0
            ? setIsOutOfItems(_ => false)
            : setIsOutOfItems(_ => true)
          data["data"]["numFound"]->setNumFound
          data->Js.log->resolve
        })
        ->catch(err => {
          setIsError(_ => true)
          switch err {
          | JsError(obj) =>
            obj->Js.Exn.message->Belt.Option.getWithDefault("Must be some non-error value")->Js.log
          | _ => Js.log("Some unknown error")
          }
          resolve()
        })
    }, 1000)

    timeOut
  }

  React.useEffect1(() => {
    setBooks(_ => [])
    None
  }, [query])

  React.useEffect2(() => {
    setIsLoading(_ => true)
    setIsError(_ => false)

    let timeOut = getData()

    Some(() => Js.Global.clearTimeout(timeOut))
  }, (query, page))

  let onScrollDown = _ => {
    setIsLoading(_ => true)
    setPage(page => page + 1)
    let timeOut = getData()
    // let _ = Js.Global.setTimeout(() => {
    //   setCardsList(ele => {
    //     Belt.Array.concat(
    //       ele->React.Children.toArray,
    //       createCardList(cardsList, page, 15, 32)->React.Children.toArray,
    //     )->React.array
    //   })
    //   setIsLoading(_ => false)
    // }, 3000)
    Js.Global.clearTimeout(timeOut)
  }

  let handleSearch = event => {
    let value = ReactEvent.Form.currentTarget(event)["value"]
    setQuery(_ => value)
    setPage(_ => 1)
    Js.log(query)
  }

  <InfiniteScroll
    isLoading
    isOutOfItems
    loadingComponent={React.string("Loading....")}
    onScrollDown
    onScrollPercent=0.8>
    <h1> {"Book Searching"->React.string} </h1>
    <label htmlFor="search"> {"Search"->React.string} </label>
    <input id="search" type_="text" onChange={handleSearch} />
    <p> {("We have found: " ++ numFound->Belt.Int.toString)->React.string} </p>
    {books->React.array}
    <div> {isError ? "We have run into a problem."->React.string : React.null} </div>
  </InfiniteScroll>
}
