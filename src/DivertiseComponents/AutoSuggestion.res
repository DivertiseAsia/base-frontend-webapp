@react.component
let make = (~triggerSymbol: string, ~triggerOptions: list<string>, ~_triggerCallback=?) => {
  let (inputValue, setInputValue) = React.useState(_ => "")
  let (filteredOptions, setFilteredOptions) = React.useState(_ => list{})
  let (showOptions, setShowOptions) = React.useState(_ => false)
  let (selectedIndex, setSelectedIndex) = React.useState(_ => 0)
  let inputRef = React.useRef(Js.Nullable.null)

  React.useEffect2(() => {
    let matchtriggerSymbol =
      inputValue->Js.Re.exec_((triggerSymbol ++ "(\S+)")->Js.Re.fromStringWithFlags(~flags="ig"), _)
    switch matchtriggerSymbol {
    | None => setFilteredOptions(_ => list{})
    | Some(match) =>
      setFilteredOptions(_ => {
        triggerOptions->Belt.List.keep(option => {
          option
          ->Js.Re.exec_(
            match
            ->Js.Re.captures
            ->Belt.Array.getExn(1)
            ->Js.Nullable.toOption
            ->Belt.Option.getExn
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

  let handleSuggestionHover = index => {
    setSelectedIndex(_ => index)
  }

  let handleSuggestionClick = suggestion => {
    setInputValue(_ =>
      inputValue->Js.String2.replaceByRe(
        `${triggerSymbol}[^${triggerSymbol}]*$`->Js.Re.fromString,
        suggestion,
      )
    )
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

  let handleInputBlur = _event => {
    setShowOptions(_ => false)
  }

  let handleInputChange = event => {
    let value = ReactEvent.Form.currentTarget(event)["value"]
    setInputValue(_ => value)
  }

  <>
    <input
      type_="text"
      ref={ReactDOM.Ref.domRef(inputRef)}
      value={inputValue}
      onBlur={handleInputBlur}
      onKeyDown={handleInputKeyDown}
      onChange={handleInputChange}
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
            onMouseOver={_ => handleSuggestionHover(index)}
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
