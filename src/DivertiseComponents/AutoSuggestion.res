type triggerType =
  | TriggerSymbol(string)
  | TriggerRegex(Js.Re.t)

@react.component
let make = (~trigger: triggerType, ~triggerOptions: list<string>, ~_triggerCallback=?) => {
  let (inputValue, setInputValue) = React.useState(_ => "")
  let (filteredOptions, setFilteredOptions) = React.useState(_ => list{})
  let (showOptions, setShowOptions) = React.useState(_ => false)
  let (selectedIndex, setSelectedIndex) = React.useState(_ => 0)
  let inputRef = React.useRef(Js.Nullable.null)

  React.useEffect2(() => {
    let matchtriggerSymbol = switch trigger {
    | TriggerSymbol(symbol) =>
      inputValue->Js.Re.exec_(
        (symbol ++ "(\S+)" ++ `|${symbol}`)->Js.Re.fromStringWithFlags(~flags="ig"),
        _,
      )
    | TriggerRegex(regex) => inputValue->Js.Re.exec_(regex, _)
    }

    switch matchtriggerSymbol {
    | None => setFilteredOptions(_ => list{})
    | Some(match) =>
      Js.log(match)
      setFilteredOptions(_ => {
        triggerOptions->Belt.List.keep(option => {
          option
          ->Js.Re.exec_(
            match
            ->Js.Re.captures
            ->Belt.Array.get(1)
            ->Belt.Option.getWithDefault(Js.Nullable.null)
            ->Js.Nullable.toOption
            ->Belt.Option.getWithDefault("")
            ->Js.Re.fromStringWithFlags(~flags="i"),
            _,
          )
          ->Js.Option.isSome
        })
      })
    }
    None
  }, (inputValue, triggerOptions))

  React.useEffect1(() => {
    setShowOptions(_ => Js.List.length(filteredOptions) > 0)
    None
  }, [filteredOptions])

  let handleSuggestionClick = suggestion => {
    switch trigger {
    | TriggerSymbol(symbol) =>
      setInputValue(_ =>
        inputValue->Js.String2.replaceByRe(
          (symbol ++ "(\S+)" ++ `|${symbol}`)->Js.Re.fromStringWithFlags(~flags="ig"),
          suggestion,
        )
      )
    | TriggerRegex(regex) =>
      setInputValue(_ => inputValue->Js.String2.replaceByRe(regex, suggestion))
    }
    setShowOptions(_ => false)
  }

  let handlePressKeyChangeHighlightOption = (event, i) => {
    ReactEvent.Keyboard.preventDefault(event)
    let nextIndex = mod(i, Js.List.length(filteredOptions))
    setSelectedIndex(_ => nextIndex)
  }

  let handleInputKeyDown = event => {
    let key = ReactEvent.Keyboard.key(event)
    if Js.List.length(filteredOptions) > 0 {
      switch key {
      | "ArrowUp" =>
        handlePressKeyChangeHighlightOption(
          event,
          selectedIndex - 1 + Js.List.length(filteredOptions),
        )
      | "ArrowDown" => handlePressKeyChangeHighlightOption(event, selectedIndex + 1)
      | "Enter" => {
          ReactEvent.Keyboard.preventDefault(event)
          filteredOptions
          ->Belt.List.get(selectedIndex)
          ->Belt.Option.mapWithDefault((), handleSuggestionClick)
        }
      | "Escape" => {
          ReactEvent.Keyboard.preventDefault(event)
          setShowOptions(_ => false)
        }
      | _ => ()
      }
    }
  }

  <>
    <input
      type_="text"
      ref={ReactDOM.Ref.domRef(inputRef)}
      value={inputValue}
      onBlur={_ => setShowOptions(_ => false)}
      onKeyDown={handleInputKeyDown}
      onChange={e => setInputValue(_ => Utils.valueFromEvent(e))}
    />
    {switch showOptions {
    | true =>
      <ul>
        {filteredOptions
        ->Belt.List.mapWithIndex((index, suggestion) => {
          let isSelected = index === selectedIndex
          <li
            key={`${index->Belt.Int.toString}-${suggestion}`}
            className={isSelected ? "selected" : ""}
            onMouseOver={_ => setSelectedIndex(_ => index)}
            onMouseDown={e => ReactEvent.Mouse.preventDefault(e)}
            onClick={_ => handleSuggestionClick(suggestion)}>
            {switch isSelected {
            | true => <strong> {suggestion->React.string} </strong>
            | false => suggestion->React.string
            }}
          </li>
        })
        ->Belt.List.toArray
        ->React.array}
      </ul>
    | false => React.null
    }}
  </>
}
