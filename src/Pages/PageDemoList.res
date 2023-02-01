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
      </li>
      <li>
        <a onClick={_ => RescriptReactRouter.push(Links.infiniteScrollAPI)}>
          {"Page Infinite-scroll APIs"->React.string}
        </a>
      </li>
      <li>
        <a onClick={_ => RescriptReactRouter.push(Links.autoSuggestion)}>
          {"Page Auto-suggestion"->React.string}
        </a>
      </li>
    </ul>
  </div>
}
