open RequestUtils
module Book = {
  type t = {
    title: string,
    authorName: string,
    publishYear: string,
    publishPlace: string,
  }
  let apiUrl = "https://openlibrary.org/search.json"

  let decode = (json): t => {
    open Json.Decode
    {
      title: json->field("title", string, _),
      authorName: json->field("author_name", string, _),
      publishYear: json->field("publish_year", string, _),
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
      let _ = requestJsonResponseToAction(
        ~headers=buildHeader(~verb=Get, None),
        ~url=`${Book.apiUrl}?q=${state.query}&page=${string_of_int(state.page)}`,
        ~successAction=json => {
          Js.log(json)
          let isOutOfItems = false
          // json["docs"]->Belt.Array.length > 0
          dispatch(SetIsOutOfItems(isOutOfItems))

          let books = list{}
          // Book.decodeList(json["data"]["docs"])

          // after get it working with a single page can uncomment below to figure out how to get multiple pages back
          // switch(state.books) {
          //   | Loading(Some(previousData)) => //concat data
          //   | _ => ()
          // }
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
  }, (state.query, state.page))

  let onScrollDown = _ => {
    dispatch(SetPage(state.page + 1))
  }

  let handleSearch = event => {
    let value = ReactEvent.Form.currentTarget(event)["value"]
    dispatch(SetQuery(value))
  }

  <InfiniteScroll
    loadingComponent={React.string("Loading....")}
    endingComponent={React.string("...End...")}
    onScrollDown
    onScrollPercent=0.8>
    <h1> {"Book Searching"->React.string} </h1>
    <label htmlFor="search"> {"Search"->React.string} </label>
    <input id="search" type_="text" onChange={handleSearch} />
    <p> {("We have found: " ++ state.totalResults->Belt.Int.toString)->React.string} </p>
    {switch state.books {
    | NotAsked => <div> {"Type something to get started"->React.string} </div>
    | Loading(Some(books)) | Success(books) => {
        let sortedData =
          books
          ->Belt.List.toArray
          ->Belt.Array.map((currentBook: Book.t) => {
            <DemoBook
              title={currentBook.title}
              author_name={[currentBook.authorName->React.string]}
              publish_year={[currentBook.publishYear->React.string]}
              publish_place={[currentBook.publishPlace->React.string]}
            />
          })
        sortedData->React.array
      }
    | Failure(error) => <div> {error->React.string} </div>
    | _ => <div> {"Type something to get started"->React.string} </div>
    }}
  </InfiniteScroll>
}
