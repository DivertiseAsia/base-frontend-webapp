open Webapi.Dom

type triggerType =
  | TriggerSymbol(string)
  | TriggerRegex(Js.Re.t)

@react.component
let make = (
  ~trigger: triggerType,
  ~triggerOptions: list<string>,
  ~_triggerCallback=?,
  ~syntaxHighlight=false,
) => {
  let (inputValue, setInputValue) = React.useState(_ => "")
  let (filteredOptions, setFilteredOptions) = React.useState(_ => list{})
  let (showOptions, setShowOptions) = React.useState(_ => false)
  let (selectedIndex, setSelectedIndex) = React.useState(_ => 0)
  let inputRef = React.useRef(Js.Nullable.null)

  let funcFinalRegex = (trigger: triggerType) =>
    switch trigger {
    | TriggerSymbol(symbol) => `${symbol}(\\S+)|${symbol}`->Js.Re.fromStringWithFlags(~flags="ig")
    | TriggerRegex(regex) => regex
    }

  React.useEffect2(() => {
    let matchtriggerSymbol = Js.Re.exec_(funcFinalRegex(trigger), inputValue)

    switch matchtriggerSymbol {
    | None => setFilteredOptions(_ => list{})
    | Some(match) =>
      setFilteredOptions(_ => {
        triggerOptions
        ->Belt.List.keep(
          option => {
            option
            ->Js.Re.exec_(
              match
              ->Js.Re.captures
              ->Belt.Array.get(1)
              ->Belt.Option.getWithDefault(Js.Nullable.null)
              ->Js.Nullable.toOption
              ->Belt.Option.getWithDefault("")
              ->Js.Re.fromStringWithFlags(~flags="ig"),
              _,
            )
            ->Js.Option.isSome
          },
        )
        ->Belt.List.sort(
          (first, second) => {
            Js.String2.localeCompare(first, second)->Belt.Float.toInt
          },
        )
      })
    }
    None
  }, (inputValue, triggerOptions))

  React.useEffect1(() => {
    setShowOptions(_ => Js.List.length(filteredOptions) > 0)
    None
  }, [filteredOptions])

  let makeIntoSpan = text => {
    `<span class="highlight" contentEditable=false>${text}</span>`
  }

  let handleSuggestionClick = suggestion => {
    setInputValue(_ => inputValue->Js.String2.replaceByRe(funcFinalRegex(trigger), suggestion))
    switch inputRef.current->Js.Nullable.toOption {
    | Some(dom) =>
      let cursorX = Element.getBoundingClientRect(dom)->DomRect.left
      let cursorY = Element.getBoundingClientRect(dom)->DomRect.top

      Element.setInnerHTML(
        dom,
        inputValue->Js.String2.replaceByRe(funcFinalRegex(trigger), makeIntoSpan(suggestion)),
      )

      Js.log2(cursorX, cursorY)

      let _ =
        document
        ->Document.asHtmlDocument
        ->Belt.Option.flatMap(document => document->HtmlDocument.body)
        ->Belt.Option.map(body => {
          body->Document.createRange->Range.setStart(dom, cursorX->Belt.Float.toInt)
        })
      Js.log3(cursorX, cursorY, range)
    | None => ()
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

  <div className="auto-suggestion-container">
    {switch syntaxHighlight {
    | true =>
      <div
        className="input-field"
        contentEditable=true
        value={inputValue}
        suppressContentEditableWarning=true
        ref={ReactDOM.Ref.domRef(inputRef)}
        onBlur={_ => setShowOptions(_ => false)}
        onKeyDown={handleInputKeyDown}
        onInput={e =>
          setInputValue(_ => {
            switch inputRef.current->Js.Nullable.toOption {
            | Some(dom) => Webapi.Dom.Element.innerHTML(dom)
            | None => ""
            }
          })}
      />
    | false =>
      <input
        type_="text"
        value={inputValue}
        onBlur={_ => setShowOptions(_ => false)}
        onKeyDown={handleInputKeyDown}
        onChange={e => setInputValue(_ => Utils.valueFromEvent(e))}
      />
    }}
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
  </div>
}
