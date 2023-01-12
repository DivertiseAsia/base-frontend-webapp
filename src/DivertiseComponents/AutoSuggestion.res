@react.component
let make = (~triggerSymbol: string, ~triggerOptions: list<string>) => {
  let (inputValue, setInputValue) = React.useState(_ => "")
  let (filteredOptions, setFilteredOptions) = React.useState(_ => list{})

  React.useEffect1(() => {
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
    None
  }, [inputValue])

  let handleInputKeyDown = event => {
    let key = ReactEvent.Keyboard.key(event)
    switch key {
    | "ArrowUp" => {
        ReactEvent.Keyboard.preventDefault(event)
        Js.log("ArrowUp")
      }
    | "ArrowDown" => {
        ReactEvent.Keyboard.preventDefault(event)
        Js.log("ArrowUp")
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

  <input type_="text" onKeyDown={handleInputKeyDown} onChange={handleInputChange} />
}
