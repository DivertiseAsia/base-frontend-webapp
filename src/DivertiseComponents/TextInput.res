@react.component
let make = (
  ~value: option<string>=?,
  ~defaultValue: option<string>=?,
  ~disabled: option<bool>=?,
  ~className: option<string>=?,
  ~type_: string,
  ~id: option<string>=?,
  ~onChange=?,
  ~onBlur=?,
  ~required=?,
  ~list=?,
  ~autoComplete=?,
  ~placeholder: option<string>=?,
) => {
  let (oldValue, setOldValue) = React.useState(() => value)
  let (textValue, setTextValue) = React.useState(() =>
    switch (value, defaultValue) {
    | (Some(""), Some(y)) => y
    | (None, Some(y)) => y
    | (Some(x), _) => x
    | (None, None) => ""
    }
  )
  if value != oldValue {
    setOldValue(_ => value)
    switch value {
    | None => setTextValue(_ => "")
    | Some(x) => setTextValue(_ => x)
    }
  }
  let valueClass = textValue === "" ? "text-input-empty" : "text-input-not-empty"
  {
    switch type_ {
    | "textarea" => <textarea
        ?id
        ?disabled
        className={"text-input " ++ valueClass ++ " " ++ Js.Option.getWithDefault("", className)}
        ?placeholder
        ?list
        ?autoComplete
        value={textValue}
        onChange={e => {
          let value = ReactEvent.Form.target(e)["value"]
          setTextValue(_ => value)
          switch onChange {
          | None => ()
          | Some(f) => f(e)
          }
        }}
        ?onBlur
        ?required
      />
    | _ => <input
        ?id
        ?disabled
        className={"text-input " ++ valueClass ++ " " ++ Js.Option.getWithDefault("", className)}
        ?placeholder
        ?list
        ?autoComplete
        value={textValue}
        onChange={e => {
          let value = ReactEvent.Form.target(e)["value"]
          setTextValue(_ => value)
          switch onChange {
          | None => ()
          | Some(f) => f(e)
          }
        }}
        ?onBlur
        type_
        ?required
      />
    }
  }
}
