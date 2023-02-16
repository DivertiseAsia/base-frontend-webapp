open Webapi.Dom

module Trigger = {
  type spanHighlightStyle = option<string>
  type optionValue = string

  type optionRecord = {
    component: React.element,
    optionValue: optionValue,
  }

  type triggerType =
    | TriggerSymbol(string)
    | TriggerRegex(string, Js.Re.t)

  type optionType =
    | OptionText(list<optionValue>)
    | OptionComponent(list<optionRecord>)

  type suggestionType =
    | SuggestedSpan(spanHighlightStyle)
    | SuggestedComponent(optionValue => React.element)

  type t = {
    triggerBy: triggerType,
    triggerOptions: optionType,
    triggerCallback?: unit => unit,
    suggestion: suggestionType,
    isReplaceSymbol: bool,
  }

  let filterTriggerOptionsByAlphabet = (triggerOption: list<string>, match: Js.Re.result) => {
    triggerOption
    ->Belt.List.keep(option => {
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
    })
    ->Belt.List.sort((first, second) => {
      Js.String2.localeCompare(first, second)->Belt.Float.toInt
    })
  }

  let createSuggestionEl = (
    ~contentEditable=false,
    ~suggestionText: string,
    ~styles: option<string>,
  ): Dom.element => {
    let span = document->Document.createElement("span")
    span->Element.setTextContent(suggestionText)
    span->Element.setAttribute("contentEditable", contentEditable->string_of_bool)
    styles->Belt.Option.mapWithDefault((), style => span->Element.setAttribute("style", style))

    span
  }
}

open Trigger

@react.component
let make = (~triggers: list<Trigger.t>) => {
  let (inputValue, setInputValue) = React.useState(_ => "")
  let (currentTrigger, setCurrentTrigger) = React.useState(_ => None)
  let (filteredOptions, setFilteredOptions) = React.useState(_ => list{})
  let (showOptions, setShowOptions) = React.useState(_ => false)
  let (selectedIndex, setSelectedIndex) = React.useState(_ => 0)
  let inputRef = React.useRef(Js.Nullable.null)

  let funcFinalSymbol = (trigger: triggerType) =>
    switch trigger {
    | TriggerSymbol(symbol) => symbol
    | TriggerRegex(symbol, _) => symbol
    }

  let funcFinalRegex = (trigger: triggerType) =>
    switch trigger {
    | TriggerSymbol(symbol) =>
      `^${symbol}(\\w*)|\\s${symbol}(\\w*)`->Js.Re.fromStringWithFlags(~flags="ig")
    | TriggerRegex(_, regex) => regex
    }

  let createOptionsText = (triggerOptions: optionType): list<Trigger.optionValue> =>
    switch triggerOptions {
    | OptionText(strList) => strList
    | OptionComponent(eleList) =>
      eleList->Belt.List.map(ele => {
        ele.optionValue
      })
    }

  let createSuggestionElement = (
    ~suggestionText: string,
    ~suggestion: suggestionType,
  ): Dom.element =>
    switch suggestion {
    | SuggestedSpan(styles) => createSuggestionEl(~contentEditable=false, ~suggestionText, ~styles)
    | SuggestedComponent(eleFn) =>
      suggestionText->eleFn->ReactDOMServer.renderToString->Utils.stringToElement
    }

  React.useEffect1(() => {
    triggers
    ->Belt.List.getBy(trigger => {
      Js.Re.exec_(
        funcFinalRegex(trigger.triggerBy),
        inputValue
        ->Js.String2.lastIndexOf(funcFinalSymbol(trigger.triggerBy))
        ->Js.String2.sliceToEnd(inputValue, ~from=_),
      )->Js.Option.isSome
    })
    ->(trigger => setCurrentTrigger(_ => trigger))
    ->ignore

    None
  }, [inputValue])

  React.useEffect2(() => {
    currentTrigger
    ->Belt.Option.mapWithDefault(None, trigger => {
      Js.Re.exec_(
        funcFinalRegex(trigger.triggerBy),
        inputValue
        ->Js.String2.lastIndexOf(funcFinalSymbol(trigger.triggerBy))
        ->Js.String2.sliceToEnd(inputValue, ~from=_),
      )->Belt.Option.map(
        match => {
          trigger.triggerOptions->createOptionsText->filterTriggerOptionsByAlphabet(match)
        },
      )
    })
    ->(
      filteredOptions => {
        setFilteredOptions(_ => filteredOptions->Belt.Option.getWithDefault(list{}))
      }
    )

    None
  }, (inputValue, currentTrigger))

  React.useEffect1(() => {
    setShowOptions(_ => Js.List.length(filteredOptions) > 0)

    None
  }, [filteredOptions])

  let handleSuggestionClick = (~suggestionText: string, ~suggestion: suggestionType) => {
    currentTrigger
    ->Belt.Option.mapWithDefault((), trigger => {
      switch inputRef.current->Js.Nullable.toOption {
      | Some(dom) =>
        if trigger.isReplaceSymbol {
          Utils.ContentEditable.updateValue(
            ~triggerRegex=funcFinalRegex(trigger.triggerBy),
            ~divEl=dom,
            createSuggestionElement(~suggestionText, ~suggestion),
          )
        } else {
          Utils.ContentEditable.updateValue(
            ~triggerRegex=funcFinalRegex(trigger.triggerBy),
            ~divEl=dom,
            createSuggestionElement(
              ~suggestionText=funcFinalSymbol(trigger.triggerBy) ++ suggestionText,
              ~suggestion,
            ),
          )
        }

      | None => ()
      }
      setCurrentTrigger(_ => None)
      setShowOptions(_ => false)
    })
    ->ignore
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
          ReactEvent.Keyboard.stopPropagation(event)
          filteredOptions
          ->Belt.List.get(selectedIndex)
          ->Belt.Option.mapWithDefault((), text => {
            currentTrigger
            ->Belt.Option.map(trigger => trigger.suggestion)
            ->Belt.Option.mapWithDefault(
              (),
              handleSuggestionClick(~suggestionText=text, ~suggestion=_),
            )
          })
        }
      | "Escape" => {
          ReactEvent.Keyboard.preventDefault(event)
          setShowOptions(_ => false)
        }
      | _ => ()
      }
    }
  }

  let selectedClassName = (~index: int, ~isSelected: bool): string => {
    if isSelected {
      `option-${index->Belt.Int.toString}-selected`
    } else {
      `option-${index->Belt.Int.toString}`
    }
  }

  let generateOption = (triggerOptions: optionType) =>
    switch triggerOptions {
    | OptionText(_) =>
      <ul>
        {filteredOptions
        ->Belt.List.mapWithIndex((index, suggestionText) => {
          let isSelected = index === selectedIndex
          <li
            key={`option-${index->Belt.Int.toString}`}
            className={selectedClassName(~index, ~isSelected)}
            onMouseOver={_ => setSelectedIndex(_ => index)}
            onMouseDown={e => ReactEvent.Mouse.preventDefault(e)}
            onClick={_ =>
              currentTrigger
              ->Belt.Option.map(trigger => trigger.suggestion)
              ->Belt.Option.mapWithDefault(
                (),
                handleSuggestionClick(~suggestionText, ~suggestion=_),
              )}>
            {switch isSelected {
            | true => <strong> {suggestionText->React.string} </strong>
            | false => suggestionText->React.string
            }}
          </li>
        })
        ->Belt.List.toArray
        ->React.array}
      </ul>
    | OptionComponent(eleList) =>
      <div className="option-wrapper">
        {filteredOptions
        ->Belt.List.mapWithIndex((index, suggestionText) => {
          let isSelected = index === selectedIndex

          eleList
          ->Belt.List.getBy(ele => ele.optionValue == suggestionText)
          ->Belt.Option.getWithDefault({
            component: <> </>,
            optionValue: "",
          })
          ->(
            ele =>
              <div
                key={`option-${index->Belt.Int.toString}`}
                className={selectedClassName(~index, ~isSelected)}
                onMouseOver={_ => setSelectedIndex(_ => index)}
                onMouseDown={e => ReactEvent.Mouse.preventDefault(e)}
                onClick={_ =>
                  currentTrigger
                  ->Belt.Option.map(trigger => trigger.suggestion)
                  ->Belt.Option.mapWithDefault(
                    (),
                    handleSuggestionClick(~suggestionText, ~suggestion=_),
                  )}>
                ele.component
              </div>
          )
        })
        ->Belt.List.toArray
        ->React.array}
      </div>
    }

  <div className="auto-suggestion-container">
    <div
      className="input-field"
      contentEditable=true
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
    {switch showOptions {
    | true =>
      currentTrigger
      ->Belt.Option.map(trigger => trigger.triggerOptions)
      ->Belt.Option.mapWithDefault(React.null, generateOption)
    | false => React.null
    }}
  </div>
}
