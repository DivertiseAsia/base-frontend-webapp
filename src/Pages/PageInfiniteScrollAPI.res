open RequestUtils
module Book = {
  open Json.Decode
  type rec t = {
    title: option<string>,
    authorName: option<array<string>>,
    publishYear: option<array<int>>,
    publishPlace: option<array<string>>,
  }
  and result = {
    docs: list<t>,
    numFound: int,
  }

  let apiUrl = "https://openlibrary.org/search.json"

  let decode = (json): t => {
    let result = {
      title: optional(field("title", string, _), json),
      authorName: optional(field("author_name", array(string), _), json),
      publishYear: optional(field("publish_year", array(int), _), json),
      publishPlace: optional(field("publish_place", array(string), _), json),
    }
    result
  }

  let decodeList = (docListJson): list<t> => {
    list(decode, docListJson)
  }

  let decodeBooksFromDocs = (json): list<t> => {
    field("docs", decodeList, json)
  }

  let decodeNumFound = (json): int => {
    field("numFound", int, json)
  }
}

type action =
  | SetQuery(string)
  | SetIsOutOfItems(bool)
  | LoadBooksRequest(WebData.apiAction<list<Book.t>>)
  | SetPage(int)
  | SetTotalResults(int)

type state = {
  query: string,
  books: WebData.t<list<Book.t>>,
  page: int,
  totalResults: int,
  isOutOfItems: bool,
}

@react.component
let make = () => {
  let (state, dispatch) = React.useReducer(
    (state, action) => {
      switch action {
      | SetQuery(query) => {
          page: 1,
          query: query,
          totalResults: 0,
          books: RemoteData.NotAsked,
          isOutOfItems: false,
        }
      | SetIsOutOfItems(isOutOfItems) => {...state, isOutOfItems: isOutOfItems}
      | SetPage(page) => {...state, page: page}
      | SetTotalResults(totalResults) => {...state, totalResults: totalResults}
      | LoadBooksRequest(bookAction) => {
          ...state,
          books: WebData.updateWebData(state.books, bookAction),
        }
      }
    },
    {
      query: "",
      books: RemoteData.NotAsked,
      page: 1,
      totalResults: 0,
      isOutOfItems: false,
    },
  )

  let getData = () => {
    let timeOut = Js.Global.setTimeout(() => {
      let _ = requestJsonResponseToAction(
        ~headers=buildWithoutHeader(~verb=Get, ()),
        ~url=`${Book.apiUrl}?q=${state.query}&page=${string_of_int(state.page)}`,
        ~successAction=json => {
          let booksDocs = json->Book.decodeBooksFromDocs
          let numFound = json->Book.decodeNumFound

          let isOutOfItems = booksDocs->Belt.List.length <= 0
          dispatch(SetIsOutOfItems(isOutOfItems))

          switch state.books {
          | Loading(Some(previousData)) | Success(previousData) => {
              dispatch(
                LoadBooksRequest(WebData.RequestSuccess(previousData->Belt.List.concat(booksDocs))),
              )
              dispatch(SetTotalResults(numFound))
            }
          | _ => {
              dispatch(LoadBooksRequest(WebData.RequestSuccess(booksDocs)))
              dispatch(SetTotalResults(numFound))
            }
          }
        },
        ~failAction=json => {
          Js.log2("failAction", json)
          // * : This APIs returns error in HTML format
          dispatch(LoadBooksRequest(WebData.RequestError("We have an error")))
        },
      )
    }, 1000)

    timeOut
  }

  React.useEffect2(() => {
    let _ = dispatch(LoadBooksRequest(WebData.RequestLoading))
    let timeOut = getData()
    Some(() => Js.Global.clearTimeout(timeOut))
  }, (state.query, state.page))

  let loadMoreItems = _ => {
    dispatch(SetPage(state.page + 1))
  }

  let handleSearch = event => {
    let value = ReactEvent.Form.currentTarget(event)["value"]
    dispatch(SetQuery(value))
  }

  // * : This div is needed to collect the height of the screen (clientHeight)
  <div className="scroll-wrapper" style={ReactDOM.Style.make(~height="100vh", ())}>
    <InfiniteScroll
      isLoading={state.books->RemoteData.isLoading}
      isOutOfItems={state.isOutOfItems}
      loadingComponent={React.string("Loading....")}
      endingComponent={React.string("...End...")}
      loadMoreItems
      onScrollPercent=0.8>
      <h1> {"Book Searching"->React.string} </h1>
      <label htmlFor="search"> {"Search"->React.string} </label>
      <input id="search" type_="text" onChange={handleSearch} />
      <p> {("We have found: " ++ state.totalResults->Belt.Int.toString)->React.string} </p>
      {switch state.books {
      | NotAsked | Loading(None) => <div> {"Type something to get started"->React.string} </div>
      | Loading(Some(books)) | Success(books) =>
        books
        ->Belt.List.toArray
        ->Belt.Array.mapWithIndex((i, (currentBook: Book.t)) => {
          <DemoBook
            key={i->Belt.Int.toString}
            className={i->Belt.Int.toString}
            title={currentBook.title->Belt.Option.getWithDefault("")}
            authorName={currentBook.authorName
            ->Belt.Option.getWithDefault([""])
            ->Belt.Array.map(_, i => i->React.string)}
            publishYear={currentBook.publishYear
            ->Belt.Option.getWithDefault([0])
            ->Belt.Array.map(_, i => i->Belt.Int.toString->React.string)}
            publishPlace={currentBook.publishPlace
            ->Belt.Option.getWithDefault([""])
            ->Belt.Array.map(_, i => i->React.string)}
          />
        })
        ->React.array
      | Failure(error) => <div> {error->React.string} </div>
      }}
    </InfiniteScroll>
  </div>
}
