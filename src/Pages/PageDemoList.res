@react.component
let make = () => {
  <div>
    <h1> {"Components list"->React.string} </h1>
    <p>
      {"list of component that showcase InfiniteScroll and AutoSuggestion components"->React.string}
    </p>
    <ul>
      <li>
        <a onClick={_ => RescriptReactRouter.push(Links.infiniteScroll)}>
          {"Page Infinite-scroll"->React.string}
        </a>
        <p>
          {"show to trigger load new demo card when scroll on percent of container's height"->React.string}
        </p>
      </li>
      <li>
        <a onClick={_ => RescriptReactRouter.push(Links.infiniteScrollAPI)}>
          {"Page Infinite-scroll APIs"->React.string}
          <p> {"show to trigger load new books from openlibrary APIs"->React.string} </p>
        </a>
      </li>
      <li>
        <a onClick={_ => RescriptReactRouter.push(Links.autoSuggestion)}>
          {"Page Auto-suggestion"->React.string}
          <p> {"show to trigger suggestion when input specific symbol"->React.string} </p>
        </a>
      </li>
    </ul>
  </div>
}
