type t<'a> = RemoteData.t<'a, option<'a>, string>

type apiAction<'a> =
  | Initial
  | RequestLoading
  | RequestError(string)
  | RequestSuccess('a)

let toLoading = (data: t<'a>): t<'a> => {
  open RemoteData
  switch data {
  | Success(data) | Loading(Some(data)) => Loading(Some(data))
  | _ => Loading(None)
  }
}

let updateWebData = (data: t<'a>, action: apiAction<'a>): t<'a> => {
  switch action {
  | Initial => RemoteData.NotAsked
  | RequestLoading => data |> toLoading
  | RequestError(error) => RemoteData.Failure(error)
  | RequestSuccess(response) => RemoteData.Success(response)
  }
}

let loadIfNoneOrError = (data: t<'a>, loadFunction: unit => unit) => {
  switch data {
  | Failure(_) | NotAsked => loadFunction()
  | _ => ()
  }
}
