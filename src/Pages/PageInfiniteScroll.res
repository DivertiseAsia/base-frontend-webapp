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
    // * : You can add your APIs here.
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
      onScrollPercent=0.9>
      <h1> {"Infinite-scroll"->React.string} </h1>
      <p> {"Showcase of using infinite-scroll with APIs"->React.string} </p>
      <button onClick={_ => RescriptReactRouter.push(Links.infiniteScrollAPI)}>
        {"Page Infinite-scroll APIs"->React.string}
      </button>
      <section
        style={ReactDOM.Style.make(
          ~margin="10px auto",
          ~padding="10px 10px",
          ~textAlign="left",
          ~border="1px solid black",
          ~width="50%",
          ~minWidth="150px",
          (),
        )}>
        <p style={ReactDOM.Style.make(~margin="5px 0px", ())}>
          <code> {"<InfiniteScroll"->React.string} </code>
        </p>
        <p style={ReactDOM.Style.make(~margin="5px 10px", ())}>
          <code> {"isLoading"->React.string} </code>
        </p>
        <p style={ReactDOM.Style.make(~margin="5px 10px", ())}>
          <code> {"isOutOfItems"->React.string} </code>
        </p>
        <p style={ReactDOM.Style.make(~margin="5px 10px", ())}>
          <code> {"loadingComponent={React.string(\"Loading....\")}"->React.string} </code>
        </p>
        <p style={ReactDOM.Style.make(~margin="5px 10px", ())}>
          <code> {"endingComponent={React.string(\"...End...\")}"->React.string} </code>
        </p>
        <p style={ReactDOM.Style.make(~margin="5px 10px", ())}>
          <code> {"loadMoreItems"->React.string} </code>
        </p>
        <p style={ReactDOM.Style.make(~margin="5px 10px", ())}>
          <code> {"onScrollPercent=0.9>"->React.string} </code>
        </p>
        <p style={ReactDOM.Style.make(~margin="5px 20px", ())}>
          <code> {"children"->React.string} </code>
        </p>
        <p style={ReactDOM.Style.make(~margin="5px 0px", ())}>
          <code> {"</InfiniteScroll>"->React.string} </code>
        </p>
      </section>
      <section
        style={ReactDOM.Style.make(
          ~margin="10px auto",
          ~padding="10px 10px",
          ~textAlign="left",
          ~border="1px solid black",
          ~width="50%",
          ~minWidth="150px",
          (),
        )}>
        <h2> {"Props list"->React.string} </h2>
        <ul>
          <li>
            {"isLoading (Boolean: default=false) : to indicate if there are any progress to load a new element"->React.string}
          </li>
          <li>
            {"isOutOfItems (Boolean: default=false) : to indicate if there are out of items"->React.string}
          </li>
          <li>
            {"loadingComponent (React component) : to show at the bottom when loading a new element"->React.string}
          </li>
          <li>
            {"endingComponent (React component) : to show at the bottom when out of items"->React.string}
          </li>
          <li>
            {"onScrollPercent (Float: default=1.0) : trigger a new loading on percent of container's height"->React.string}
          </li>
          <li>
            {"children (React component) : items to show in Infinite-scroll component"->React.string}
          </li>
        </ul>
      </section>
      cardsList
    </InfiniteScroll>
  </div>
}
