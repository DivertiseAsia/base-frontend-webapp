@react.component
let make = (~triggerSymbol: string, ~triggerOptions: list<string>, ~_triggerCallback=?) => {
  let (inputValue, setInputValue) = React.useState(_ => "")
  let (filteredOptions, setFilteredOptions) = React.useState(_ => list{})
  let (showOptions, setShowOptions) = React.useState(_ => false)
  let (selectedIndex, setSelectedIndex) = React.useState(_ => 0)
  let inputRef = React.useRef(Js.Nullable.null)

  React.useEffect2(() => {
    let atIndex = inputValue->Js.String2.lastIndexOf(triggerSymbol)
    switch atIndex {
    | -1 => setFilteredOptions(_ => list{})
    | _ => {
        let prefix = inputValue->Js.String2.sliceToEnd(~from=atIndex + 1)
        setFilteredOptions(_ => {
          triggerOptions->Belt.List.keep(option => {
            option
            ->Js.Re.exec_(prefix->Js.Re.fromStringWithFlags(~flags="i"), _)
            ->Js.Option.isSome
          })
        })
        switch Js.List.length(filteredOptions) {
        | 0 => setShowOptions(_ => false)
        | _ => setShowOptions(_ => true)
        }
      }
    }
    None
  }, (inputValue, triggerOptions))

  let handleSuggestionClick = suggestion => {
    setInputValue(_ =>
      inputValue->Js.String2.replaceByRe(
        `${triggerSymbol}[^${triggerSymbol}]*$`->Js.Re.fromString,
        suggestion,
      )
    )
    setShowOptions(_ => false)
  }

  let handleSuggestionHover = index => {
    setSelectedIndex(_ => index)
  }

  let handleInputKeyDown = event => {
    let key = ReactEvent.Keyboard.key(event)
    switch Js.List.length(filteredOptions) {
    | 0 => ()
    | _ =>
      switch key {
      | "ArrowUp" => {
          ReactEvent.Keyboard.preventDefault(event)
          let nextIndex = mod(
            selectedIndex - 1 + Js.List.length(filteredOptions),
            Js.List.length(filteredOptions),
          )
          setSelectedIndex(_ => nextIndex)
        }
      | "ArrowDown" => {
          ReactEvent.Keyboard.preventDefault(event)
          let nextIndex = mod(selectedIndex + 1, Js.List.length(filteredOptions))
          setSelectedIndex(_ => nextIndex)
        }
      | "Enter" => {
          ReactEvent.Keyboard.preventDefault(event)
          handleSuggestionClick(Belt.List.toArray(filteredOptions)[selectedIndex])
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
        ->Belt.List.mapWithIndex((index, suggestion) =>
          <li
            key={suggestion}
            className={index === selectedIndex ? "selected" : ""}
            onMouseOver={_ => handleSuggestionHover(index)}
            onMouseDown={e => ReactEvent.Mouse.preventDefault(e)}
            onClick={_ => handleSuggestionClick(suggestion)}>
            {switch index === selectedIndex {
            | true => <strong> {suggestion->React.string} </strong>
            | false => suggestion->React.string
            }}
          </li>
        )
        ->Belt.List.toArray
        ->React.array}
      </ul>
    | false => React.null
    }}
  </>
}
