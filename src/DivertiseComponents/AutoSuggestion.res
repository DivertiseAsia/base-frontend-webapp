open Webapi.Dom

module Trigger = {
  type spanHighlightStyle = option<string>

  type optionRecord = {
    component: React.element,
    value: string,
  }

  type triggerType =
    | TriggerSymbol(string)
    | TriggerRegex(Js.Re.t)

  type optionType =
    | OptionText(list<string>)
    | OptionComponent(list<optionRecord>)

  type suggestionType =
    | SuggestedSpan(spanHighlightStyle)
    | SuggestedComponent(React.element)

  type t = {
    triggerBy: triggerType,
    triggerOptions: optionType,
    triggerCallback?: unit => unit,
    suggestion: suggestionType,
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

  let funcFinalRegex = (trigger: triggerType) =>
    switch trigger {
    | TriggerSymbol(symbol) =>
      `^${symbol}(\\w*)|\\s${symbol}(\\w*)`->Js.Re.fromStringWithFlags(~flags="ig")
    | TriggerRegex(regex) => regex
    }

  let funcFinalOption = (triggerOptions: optionType) =>
    switch triggerOptions {
    | OptionText(strList) => strList
    | OptionComponent(eleList) =>
      eleList->Belt.List.map(ele => {
        ele.value
      })
    }

  let createFinalSuggestion = (~suggestionText: string, ~suggestion: suggestionType) =>
    switch suggestion {
    | SuggestedSpan(style) =>
      createSuggestionEl(~contentEditable=false, ~suggestionText, ~styles=style)
    | SuggestedComponent(_) =>
      createSuggestionEl(~contentEditable=false, ~suggestionText, ~styles=None)
    }

  React.useEffect1(() => {
    triggers
    ->Belt.List.getBy(trigger => {
      Js.Re.exec_(funcFinalRegex(trigger.triggerBy), inputValue)->Js.Option.isSome
    })
    ->(trigger => setCurrentTrigger(_ => trigger))
    ->ignore

    None
  }, [inputValue])

  React.useEffect2(() => {
    currentTrigger
    ->Belt.Option.mapWithDefault(None, trigger => {
      Js.log2("exec", Js.Re.exec_(funcFinalRegex(trigger.triggerBy), inputValue))
      Js.Re.exec_(funcFinalRegex(trigger.triggerBy), inputValue)->Belt.Option.map(
        match => {
          trigger.triggerOptions->funcFinalOption->filterTriggerOptionsByAlphabet(match)
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
        Utils.ContentEditable.updateValue(
          ~triggerRegex=funcFinalRegex(trigger.triggerBy),
          ~divEl=dom,
          createFinalSuggestion(~suggestionText, ~suggestion),
        )
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
            // TODO : use getWithDefault instead
            currentTrigger
            ->Belt.Option.map(trigger => trigger.suggestion)
            ->Belt.Option.getExn
            ->handleSuggestionClick(~suggestionText=text, ~suggestion=_)
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

  let generateOption = (triggerOptions: optionType) =>
    switch triggerOptions {
    | OptionText(_) =>
      <ul>
        {filteredOptions
        ->Belt.List.mapWithIndex((index, suggestion) => {
          let isSelected = index === selectedIndex
          <li
            key={`${index->Belt.Int.toString}-${suggestion}`}
            className={isSelected ? "selected" : ""}
            onMouseOver={_ => setSelectedIndex(_ => index)}
            onMouseDown={e => ReactEvent.Mouse.preventDefault(e)}
            onClick={_ =>
              currentTrigger
              ->Belt.Option.map(trigger => trigger.suggestion)
              ->Belt.Option.getExn
              ->handleSuggestionClick(~suggestionText=suggestion, ~suggestion=_)}>
            {switch isSelected {
            | true => <strong> {suggestion->React.string} </strong>
            | false => suggestion->React.string
            }}
          </li>
        })
        ->Belt.List.toArray
        ->React.array}
      </ul>
    | OptionComponent(eleList) =>
      filteredOptions
      ->Belt.List.mapWithIndex((index, suggestion) => {
        // let isSelected = index === selectedIndex

        eleList
        ->Belt.List.getBy(ele => ele.value == suggestion)
        ->Belt.Option.getWithDefault({
          component: <> </>,
          value: "",
        })
        ->(
          ele =>
            <div
              onMouseOver={_ => setSelectedIndex(_ => index)}
              onMouseDown={e => ReactEvent.Mouse.preventDefault(e)}
              onClick={_ =>
                currentTrigger
                ->Belt.Option.map(trigger => trigger.suggestion)
                ->Belt.Option.getExn
                ->handleSuggestionClick(~suggestionText=suggestion, ~suggestion=_)}>
              ele.component
            </div>
        )
      })
      ->Belt.List.toArray
      ->React.array
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
      generateOption(
        // TODO : use getWithDefault instead
        currentTrigger->Belt.Option.map(trigger => trigger.triggerOptions)->Belt.Option.getExn,
      )
    | false => React.null
    }}
  </div>
}
