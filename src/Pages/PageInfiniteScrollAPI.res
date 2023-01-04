open RequestUtils
module Book = {
  type t = {
    title: string,
    authorName: string,
    publishYear: int,
    publishPlace: string,
  }
  let apiUrl = "https://openlibrary.org/search.json"

  let decode = (json): t => {
    open Json.Decode
    {
      title: json->field("title", string, _),
      authorName: json->field("author_name", string, _),
      publishYear: json->field("publish_year", int, _),
      publishPlace: json->field("publish_place", string, _),
    }
  }

  let decodeList = (json): list<t> => Json.Decode.list(decode, json)
}

type action =
  | SetQuery(string)
  | SetIsOutOfItems(bool)
  | LoadBooksRequest(WebData.apiAction<list<Book.t>>)
  | SetPage(int)

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
      let _ = dispatch(LoadBooksRequest(WebData.RequestLoading))
      requestJsonResponseToAction(
        ~headers=buildHeader(~verb=Get, None),
        ~url=`${Book.apiUrl}?q=${state.query}&page=${string_of_int(state.page)}`,
        ~successAction=json => {
          let isOutOfItems = json["data"]["docs"]->Belt.Array.length > 0
          dispatch(SetIsOutOfItems(isOutOfItems))

          let books = Book.decodeList(json["data"]["docs"])
          dispatch(LoadBooksRequest(WebData.RequestSuccess(books)))
        },
        ~failAction=json => {
          Js.log(json)
          // TODO: make it use error from json instead of hardcode
          dispatch(LoadBooksRequest(WebData.RequestError("We have run into a problem.")))
        },
      )
    }, 1000)

    timeOut
  }

  React.useEffect2(() => {
    let timeOut = getData()
    Some(() => Js.Global.clearTimeout(timeOut))
  }, (query, page))

  let onScrollDown = _ => {
    setPage(page => page + 1)
  }

  let handleSearch = event => {
    let value = ReactEvent.Form.currentTarget(event)["value"]
    dispatch(SetQuery(value))
  }

  <InfiniteScroll
    isLoading
    isOutOfItems
    loadingComponent={React.string("Loading....")}
    endingComponent={React.string("...End...")}
    onScrollDown
    onScrollPercent=0.8>
    <h1> {"Book Searching"->React.string} </h1>
    <label htmlFor="search"> {"Search"->React.string} </label>
    <input id="search" type_="text" onChange={handleSearch} />
    <p> {("We have found: " ++ numFound->Belt.Int.toString)->React.string} </p>
    {switch state.books {
    | NotAsked => <div> {"Type something to get started"} </div>
    | Loading(Some(books)) | Success(books) => {
        let sortedData = Belt.Array.map(books, (currentBook: Book.t) => {
          <CardAPI
            title={currentBook.title}
            author_name={currentBook.authorName}
            publish_year={currentBook.publishYear}
            publish_place={currentBook.publishPlace}
          />
        })->React.array
      }
    | Error(error) => <div> {error->React.string} </div>
    }}
  </InfiniteScroll>
}
