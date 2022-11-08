module Translation = {
  type t = {
    id: string,
    defaultMessage: string,
    message: Js.nullable<string>,
  }

  let toDict = (translations: array<t>) =>
    translations->Belt.Array.reduce(Js.Dict.empty(), (dict, entry) => {
      dict->Js.Dict.set(
        entry.id,
        switch entry.message->Js.Nullable.toOption {
        | None
        | Some("") =>
          entry.defaultMessage
        | Some(message) => message
        },
      )
      dict
    })
}

@module external en: array<Translation.t> = "../../../src/translations/en.json"
@module external th: array<Translation.t> = "../../../src/translations/th.json"

type locale =
  | En
  | Th

let all = [En, Th]

let toString = x =>
  switch x {
  | En => "en"
  | Th => "th"
  }

let translations = x =>
  switch x {
  | En => en
  | Th => th
  }
