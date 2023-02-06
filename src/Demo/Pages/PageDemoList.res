@react.component
let make = () => {
  <div className="center-wrapper">
    <h1> {"Components list"->React.string} </h1>
    {Utils.createUnorderedList([
      <>
        <h2> {"Pages"->React.string} </h2>
        {Utils.createUnorderedList([
          <>
            <h3> {"Page Login"->React.string} </h3>
            <p> {"Example login with email, password, and validator."->React.string} </p>
            <button onClick={_ => RescriptReactRouter.push(Links.login)}>
              {"Page Login"->React.string}
            </button>
          </>,
          <>
            <h3> {"Page Register"->React.string} </h3>
            <p> {"Example register for newcomer with email and password."->React.string} </p>
            <button onClick={_ => RescriptReactRouter.push(Links.register)}>
              {"Page Register"->React.string}
            </button>
          </>,
          <>
            <h3> {"Page Forgot password"->React.string} </h3>
            <p>
              {"Example forgot password page to reset password from email link."->React.string}
            </p>
            <button onClick={_ => RescriptReactRouter.push(Links.forgot)}>
              {"Page Forgot password"->React.string}
            </button>
          </>,
        ])}
      </>,
      <>
        <h2> {"Components"->React.string} </h2>
        {Utils.createUnorderedList([
          <>
            <h3> {"Page Infinite-scroll"->React.string} </h3>
            <p>
              {"show to trigger load new demo card when scroll on percent of container's height"->React.string}
            </p>
            <button onClick={_ => RescriptReactRouter.push(Links.infiniteScroll)}>
              {"Page Infinite-scroll"->React.string}
            </button>
          </>,
          <>
            <h3> {"Page Infinite-scroll APIs"->React.string} </h3>
            <p> {"show to trigger load new books from openlibrary APIs"->React.string} </p>
            <button onClick={_ => RescriptReactRouter.push(Links.infiniteScrollAPI)}>
              {"Page Infinite-scroll APIs"->React.string}
            </button>
          </>,
          <>
            <h3> {"Page Auto-suggestion"->React.string} </h3>
            <p> {"show to trigger suggestion when input specific symbol"->React.string} </p>
            <button onClick={_ => RescriptReactRouter.push(Links.autoSuggestion)}>
              {"Page Auto-suggestion"->React.string}
            </button>
          </>,
        ])}
      </>,
    ])}
  </div>
}
