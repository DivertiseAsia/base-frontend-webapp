@react.component
let make = (~triggerSymbol: string, ~triggerOptions: list<string>) => {
  let (inputValue, setInputValue) = React.useState(_ => "")
  let (filteredOptions, setFilteredOptions) = React.useState(_ => list{})
  let (showOptions, setShowOptions) = React.useState(_ => false)
  let (selectedIndex, setSelectedIndex) = React.useState(_ => 0)

  React.useEffect2(() => {
    let atIndex = inputValue->Js.String2.lastIndexOf(triggerSymbol)
    switch atIndex {
    | -1 => setFilteredOptions(_ => list{})
    | _ => {
        let prefix = inputValue->Js.String2.sliceToEnd(~from=atIndex + 1)
        setFilteredOptions(_ => {
          triggerOptions->Belt.List.keep(option => {
            switch option->Js.Re.exec_(prefix->Js.Re.fromStringWithFlags(~flags="i"), _) {
            | Some(_) => true
            | None => false
            }
          })
        })
      }
    }
    setShowOptions(_ => true)
    None
  }, (inputValue, triggerOptions))

  let handleInputKeyDown = event => {
    let key = ReactEvent.Keyboard.key(event)
    switch key {
    | "ArrowUp" => {
        ReactEvent.Keyboard.preventDefault(event)
        let nextIndex = mod(
          selectedIndex - 1 + Js.List.length(filteredOptions),
          Js.List.length(filteredOptions)
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
        Js.log("Enter")
      }
    | _ => ()
    }
  }

  let handleInputChange = event => {
    let value = ReactEvent.Form.currentTarget(event)["value"]
    setInputValue(_ => value)
  }

  <>
    <input type_="text" onKeyDown={handleInputKeyDown} onChange={handleInputChange} />
    {switch showOptions {
    | true =>
      <ul>
        {filteredOptions
        ->Belt.List.mapWithIndex((index, suggestion) =>
          <li key={suggestion} className={index === selectedIndex ? "selected" : ""}>
            {suggestion->React.string}
          </li>
        )
        ->Belt.List.toArray
        ->React.array}
      </ul>
    | false => React.null
    }}
  </>
}
