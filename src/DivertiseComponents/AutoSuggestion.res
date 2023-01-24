open Webapi.Dom

type triggerType =
  | TriggerSymbol(string)
  | TriggerRegex(Js.Re.t)

let parentId = "test-div-contenteditable" //TODO: change parentID to prop or sth

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

  let makeIntoSpan = (text, extraId) => {
    `<span class="highlight" contentEditable=false data-extra-id="${extraId}" >${text}</span>`
  }

  let handleSuggestionClick = suggestion => {
    // let newInputValue =
    //   inputValue->Js.String2.replaceByRe(funcFinalRegex(trigger), makeIntoSpan(suggestion, "1"))
    Js.log2(">>> funcFinalRegex(trigger): ", funcFinalRegex(trigger))
    switch inputRef.current->Js.Nullable.toOption {
    | Some(dom) =>
      //  ---- For debug will remove
      // let beforeUpdateSel = Webapi.Dom.Window.getSelection(Webapi.Dom.window)
      // let beforeUpdateFocusNode =
      //   beforeUpdateSel->Belt.Option.mapWithDefault(None, Webapi.Dom.Selection.focusNode)
      // Js.log2(">>> before update innerHTML selection!: ", beforeUpdateSel)
      // Js.log2(">>> before update innerHTML focusnode!: ", beforeUpdateFocusNode)
      // Js.log2(">>> dom: ", dom)
      // Element.setInnerHTML(dom, newInputValue)
      // let afterUpdateSel = Webapi.Dom.Window.getSelection(Webapi.Dom.window)
      // let afterUpdateFocusNode = beforeUpdateSel->Belt.Option.map(Webapi.Dom.Selection.focusNode)
      // Js.log2(">>> after update innerHTML selection!: ", afterUpdateSel)
      // Js.log2(">>> after update innerHTML focusnode!: ", afterUpdateFocusNode)
      //  ---- For debug will remove

      Utils.ContentEditable.updateValue(~divEl=dom, suggestion, funcFinalRegex(trigger))
      setInputValue(_ => dom->Element.innerHTML)

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
          ReactEvent.Keyboard.stopPropagation(event)
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
    } else {
      switch key {
      | "Escape" =>
        Js.log2(">>> CURRENT selection!: ", Webapi.Dom.Window.getSelection(Webapi.Dom.window))
        switch inputRef.current->Js.Nullable.toOption {
        | Some(el) => Webapi.Dom.Element.childNodes(el)->Js.log2(" >>> nodeList: ", _)
        | _ => Js.log(">>> no nodeList")
        }
      | _ => ()
      }
    }
  }
  // Js.log2(">>> inputValue: ", inputValue)
  <div className="auto-suggestion-container">
    <p className="asss">
      <span className="header-text"> {React.string("TESTTTT")} </span>
    </p>
    {switch syntaxHighlight {
    | true =>
      <div
        id=parentId
        className="input-field"
        contentEditable=true
        // value={inputValue}
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
