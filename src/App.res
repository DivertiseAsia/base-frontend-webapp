@get external location: Dom.window => Dom.location = "location"
@get external href: Dom.location => string = "href"

type rootAction =
  | RouteTo(RescriptReactRouter.url)
  | UserRequest(WebData.apiAction<User.profile>)
  | ChangeToken(string)
  | Logout
  | SetLocale(Locale.locale)

type state = {
  route: RescriptReactRouter.url,
  user: WebData.t<User.profile>,
  locale: Locale.locale,
  token: string,
}

@val external window: option<Dom.window> = "window"
let path = () =>
  switch window {
  | None => ""
  | Some(window: Dom.window) => window |> location |> href
  }

@react.component
let make = () => {
  let (state, dispatch) = React.useReducer(
    (state, action) =>
      switch (action: rootAction) {
      | RouteTo(route) => {...state, route}
      | UserRequest(userRequest) => {...state, user: WebData.updateWebData(state.user, userRequest)}
      | ChangeToken(token) => {
          User.saveToken(token)
          {...state, token}
        }
      | Logout => {
          User.clearToken()
          {
            ...state,
            token: "",
            user: RemoteData.NotAsked,
          }
        }
      | SetLocale(locale) => {...state, locale}
      },
    {
      route: RescriptReactRouter.dangerouslyGetInitialUrl(),
      user: RemoteData.NotAsked,
      locale: Locale.En,
      token: User.loadToken(),
    },
  )
  React.useEffect0(() => {
    let watcherID = RescriptReactRouter.watchUrl(url => dispatch(RouteTo(url)))
    Some(() => RescriptReactRouter.unwatchUrl(watcherID))
  })

  React.useEffect1(() => {
    if state.token !== "" {
      Api.getProfile(~token=state.token, ~callback=x => dispatch(UserRequest(x))) |> ignore
    } else {
      Js.log("User is logged out")
    }
    None
  }, [state.token])

  let user = switch state.user {
  | Success(x) | Loading(Some(x)) => Some(x)
  | _ => None
  }

  let userContextValues: User.Context.contextValue = {
    user,
    setToken: x => dispatch(ChangeToken(x)),
    token: state.token,
  }
  <User.Context.Provider value=userContextValues>
    <ReactIntl.IntlProvider
      locale={state.locale->Locale.toString}
      messages={state.locale->Locale.translations->Locale.Translation.toDict}>
      {switch user {
      | Some(user) =>
        switch state.route.path {
        | list{} => <PageHome user />
        | list{"logout"} =>
          let _ = RescriptReactRouter.replace("")
          dispatch(Logout) |> ignore
          <PageLogin queryString={state.route.search} />
        | _ => <Page404 />
        }
      | None =>
        switch state.route.path {
        | list{"infinite-scroll"} => <PageInfiniteScroll />
        | list{"infinite-scroll-api"} => <PageInfiniteScrollAPI />
        | list{"auto-suggestion"} => <PageAutoSuggestion />
        | list{"register"} => <PageRegister queryString={state.route.search} />
        | list{"forgot"} => <PageForgot queryString={state.route.search} />
        | list{"reset"} => <PageResetConfirm queryString={state.route.search} />
        | list{"login"} => <PageLogin queryString={state.route.search} />
        | _ => <PageDemoList />
        }
      }}
    </ReactIntl.IntlProvider>
  </User.Context.Provider>
}
