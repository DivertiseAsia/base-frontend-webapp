type t = {email: string}

module Profile = {
  type t = {
    first_name: string,
    last_name: string,
    email: string,
  }

  let decode = (json: Js.Json.t): t => {
    open Json.Decode
    {
      email: field("email", string) |> withDefault("", _, json),
      first_name: field("first_name", string) |> withDefault("", _, json),
      last_name: field("last_name", string) |> withDefault("", _, json),
    }
  }

  let encode = (obj: t) => {
    open Json.Encode
    open Js.Dict
    let payload = empty()
    set(payload, "first_name", obj.first_name |> string)
    set(payload, "last_name", obj.last_name |> string)
    set(payload, "email", obj.email |> string)
    payload
  }
}

type profile = Profile.t

let loadToken = () => {
  open Dom.Storage
  switch localStorage |> getItem(Config.Info.tokenName) {
  | None => ""
  | Some(token) => token
  }
}

let saveToken = (token: string) => {
  open Dom.Storage
  localStorage |> setItem(Config.Info.tokenName, token)
}

let clearToken = () => {
  open Dom.Storage
  localStorage |> removeItem(Config.Info.tokenName)
}

type user = t

module Context = {
  type contextValue = {
    user: option<profile>,
    setToken: string => unit,
    token: string,
  }
  let initValue: contextValue = {user: None, setToken: _ => ignore(), token: ""}

  let context = React.createContext(initValue)

  let getContext = () => React.useContext(context)

  let getUser = () => getContext().user
  let getSetToken = () => getContext().setToken
  let getToken = () => getContext().token

  module Provider = {
    let make = React.Context.provider(context)

    /* * Tell bucklescript how to translate props into JS */
    let makeProps = (~value, ~children, ()) =>
      {
        "value": value,
        "children": children,
      }
  }
}
