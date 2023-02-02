@react.component
let make = () => {
  <div
    style={ReactDOM.Style.make(
      ~margin="10px auto",
      ~padding="10px 10px",
      ~textAlign="left",
      ~border="1px solid black",
      ~width="50%",
      ~minWidth="150px",
      (),
    )}>
    <h1> {"Components list"->React.string} </h1>
    <p>
      {"list of pages that showcase InfiniteScroll and AutoSuggestion components"->React.string}
    </p>
    {Utils.createUnorderedList([
      <>
        <button onClick={_ => RescriptReactRouter.push(Links.login)}>
          {"Page Login"->React.string}
        </button>
      </>,
      <>
        <button onClick={_ => RescriptReactRouter.push(Links.register)}>
          {"Page Register"->React.string}
        </button>
      </>,
      <>
        <button onClick={_ => RescriptReactRouter.push(Links.forgot)}>
          {"Page Forgot password"->React.string}
        </button>
      </>,
      <>
        <button onClick={_ => RescriptReactRouter.push(Links.infiniteScroll)}>
          {"Page Infinite-scroll"->React.string}
        </button>
        <p>
          {"show to trigger load new demo card when scroll on percent of container's height"->React.string}
        </p>
      </>,
      <>
        <button onClick={_ => RescriptReactRouter.push(Links.infiniteScrollAPI)}>
          {"Page Infinite-scroll APIs"->React.string}
        </button>
        <p> {"show to trigger load new books from openlibrary APIs"->React.string} </p>
      </>,
      <>
        <button onClick={_ => RescriptReactRouter.push(Links.autoSuggestion)}>
          {"Page Auto-suggestion"->React.string}
        </button>
        <p> {"show to trigger suggestion when input specific symbol"->React.string} </p>
      </>,
    ])}
  </div>
}
