let buildHeader = (
  ~verb: Fetch.requestMethod=Get,
  ~body: option<Js.Dict.t<Js.Json.t>>=?,
  token: option<string>,
) => {
  let headers = switch token {
  | None => Fetch.HeadersInit.make({"Content-Type": "application/json"})
  | Some(token) =>
    Fetch.HeadersInit.make({"Content-Type": "application/json", "Authorization": "Token " ++ token})
  }

  switch body {
  | None => Fetch.RequestInit.make(~method_=verb, ~headers, ())
  | Some(body) =>
    Fetch.RequestInit.make(
      ~method_=verb,
      ~body=Fetch.BodyInit.make(Js.Json.stringify(Js.Json.object_(body))),
      ~headers,
      (),
    )
  }
}

let buildHeaderJson = (
  ~verb: Fetch.requestMethod=Get,
  ~body: option<Js.Json.t>=?,
  token: option<string>,
) => {
  let headers = switch token {
  | None => Fetch.HeadersInit.make({"Content-Type": "application/json"})
  | Some(token) =>
    Fetch.HeadersInit.make({"Content-Type": "application/json", "Authorization": "Token " ++ token})
  }

  switch body {
  | None => Fetch.RequestInit.make(~method_=verb, ~headers, ())
  | Some(body) =>
    Fetch.RequestInit.make(
      ~method_=verb,
      ~body=Fetch.BodyInit.make(Js.Json.stringify(body)),
      ~headers,
      (),
    )
  }
}

let buildFileHeader = (~body, token: option<string>) => {
  let headers = switch token {
  | None => Fetch.HeadersInit.makeWithArray([])
  | Some(token) => Fetch.HeadersInit.make({"Authorization": "Token " ++ token})
  }

  Fetch.RequestInit.make(
    ~method_=Post,
    ~body=Fetch.BodyInit.make(Js.Json.stringify(body)),
    ~headers,
    (),
  )
}

let makeFormData: (Fetch.blob, string) => Fetch.formData = %raw(`
    function(param1, key) {
      var fd = new FormData();
      fd.append(key, param1);
      return fd;
    }
`)

let buildUploadFileHeader = (~method_, ~token, ~file, ~key) => {
  let authHeader = Fetch.HeadersInit.make({"Authorization": "Token " ++ token})
  let formdata = makeFormData(file, key)
  Fetch.RequestInit.make(
    ~method_,
    ~body=Fetch.BodyInit.makeWithFormData(formdata),
    ~headers=authHeader,
    (),
  )
}

let decode = (json, decoder) => {
  switch json |> decoder {
  | data => Some(data)
  | exception Json.Decode.DecodeError(err) => {
      Js.log2("Error decoding json", err)
      None
    }
  }
}

let request = (headers, url, ~decoder=?, ()) => {
  open Js.Promise
  Fetch.fetchWithInit(url, headers)
  |> then_(Fetch.Response.json)
  |> then_(json =>
    switch decoder {
    | Some(decoder) => json |> decoder |> (response => resolve(Some(response)))
    | None => resolve(None)
    }
  )
  |> catch(err => {
    Js.log2("Request failure -> " ++ url, err)
    resolve(None)
  })
}

let requestWithoutHeader = (~url, ~decoder=?, ()) => {
  open Js.Promise
  Fetch.fetch(url)
  |> then_(Fetch.Response.json)
  |> then_(json =>
    switch decoder {
    | Some(decoder) => json |> decoder |> (response => resolve(Some(response)))
    | None => resolve(None)
    }
  )
  |> catch(err => {
    Js.log2("Request failure -> " ++ url, err)
    resolve(None)
  })
}

let requestJsonResponseToAction = (~headers, ~url, ~successAction, ~failAction) => {
  open Js.Promise

  Fetch.fetchWithInit(url, headers)
  |> then_(response =>
    response
    |> Fetch.Response.status
    |> (
      x =>
        switch x {
        | status if status / 100 == 2 =>
          Fetch.Response.json(response)
          |> then_(json => successAction(json) |> resolve)
          |> catch(_err => successAction(Js.Json.null) |> resolve)
        | _ => Fetch.Response.json(response) |> then_(json => failAction(json) |> resolve)
        }
    )
  )
  |> catch(err => {
    Js.log2("Request failure -> " ++ url, err)
    resolve(failAction(Js.Json.string("Something went wrong. Please try again.")))
  })
}
