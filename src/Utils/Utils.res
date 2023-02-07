let preventDefault = e => ReactEvent.Mouse.preventDefault(e)

let preventDefaultForm = e => ReactEvent.Form.preventDefault(e)

let valueFromEvent = event => ReactEvent.Form.target(event)["value"]

let boolFromCheckbox = (event): bool => ReactEvent.Form.target(event)["checked"]

let saveToLocalStorage = (key, data) => Dom.Storage.setItem(key, data, Dom.Storage.localStorage)

let loadFromLocalStorage = key => Dom.Storage.getItem(key, Dom.Storage.localStorage)

let createUnorderedList = (elements: array<React.element>) => {
  <ul>
    {elements
    ->Js.Array2.mapi((element, index) => {
      <li key={`element-${index->Belt.Int.toString}`}> {element} </li>
    })
    ->React.array}
  </ul>
}

let createOrderedList = (elements: array<React.element>) => {
  <ol>
    {elements
    ->Js.Array2.mapi((element, index) => {
      <li key={`element-${index->Belt.Int.toString}`}> {element} </li>
    })
    ->React.array}
  </ol>
}

let getResponseMsgFromJson = json => {
  let jsonString = Json.stringify(json)
  let re = Js.Re.fromStringWithFlags("[\\[\\]\\{\\}\"]", ~flags="g")
  let splitMsg = Js.String.split(":", Js.String.replaceByRe(re, "", jsonString))
  splitMsg[Js.Array.length(splitMsg) - 1]
}

let clamp = (number, ~min, ~max) => {
  if number <= min {
    min
  } else if number >= max {
    max
  } else {
    number
  }
}

let floatToStringPrecision = (number: float, precision: int) => {
  let floatString = Js.Float.toFixedWithPrecision(number, ~digits=precision)
  let splitNumber = Js.String.split(".", floatString)
  let commaNumber = splitNumber[0]
  let result = switch precision {
  | 0 => commaNumber
  | _ => commaNumber ++ "." ++ splitNumber[1]
  }
  result
}

let checkWholeNumberFromStr = text =>
  switch Js.String.match_(Js.Re.fromStringWithFlags("^\\s*\\d+\\s*$", ~flags="g"), text) {
  | None => text === "" ? true : false
  | Some(_arr) => Js.String.length(text) < 7 ? true : false
  }

let checkIntfromStr = text =>
  switch Js.String.match_(Js.Re.fromStringWithFlags("^\\s*-?\\d+\\s*$", ~flags="g"), text) {
  | None => text === "" ? true : false
  | Some(_arr) => Js.String.length(text) < 7 ? true : false
  }

let checkFloatfromStr: string => bool = %raw(`
  function(value) {
    if (/^-?\d*[.,]?\d{0,2}$/.test(value))
      return true;
    else
      return false;
  }
`)

let checkPasswordValidation: string => bool = %raw(`
  function(value) {
    return !(value && /\d/.test(value) && /[A-Z]/.test(value)
      && /[a-z]/.test(value) && /\W/.test(value) && value.length >= 10);
  }
`)

let floatToCurrencyPrecision = (number: float, precision: int) => {
  let floatString = Js.Float.toFixedWithPrecision(number, ~digits=precision)
  let splitNumber = Js.String.split(".", floatString)
  let re = Js.Re.fromStringWithFlags("\\B(?=(\\d{3})+(?!\\d))", ~flags="g")
  let commaNumber = Js.String.replaceByRe(re, ",", splitNumber[0])
  let result = switch precision {
  | 0 => "$ " ++ commaNumber
  | _ => "$ " ++ commaNumber ++ "." ++ splitNumber[1]
  }
  result
}

let floatToCurrency = number => floatToCurrencyPrecision(number, 0)

let toUpperFirstChar = str =>
  (str |> Js.String.charAt(0) |> Js.String.toUpperCase) ++ (str |> Js.String.sliceToEnd(~from=1))

module MapOption = {
  let mapOpt = (opt, ~defaultValue) =>
    switch opt {
    | None => defaultValue
    | Some(value) => value
    }

  let mapOptStr = optStr => optStr |> mapOpt(~defaultValue="")
  let mapOptOptStr = (optOptStr: option<option<string>>) =>
    optOptStr |> mapOpt(~defaultValue=None) |> mapOptStr
  let mapOptInt = optInt => optInt |> mapOpt(~defaultValue=0)
  let mapOptFloat = optFloat => optFloat |> mapOpt(~defaultValue=0.)
  let mapOptList = optList => optList |> mapOpt(~defaultValue=[])

  let mapOptFloatToStr = optFloat => optFloat |> mapOptFloat |> Js.Float.toString
}

let checkStr = (~text, ~limit) =>
  switch Js.String.match_(Js.Re.fromStringWithFlags(".*\\S.*", ~flags="g"), text) {
  | None => ""
  | Some(arr) => Js.String.slice(~from=0, ~to_=limit, Js.Array.joinWith("", arr))
  }

let checkStrWithoutSpace = (~text, ~limit) =>
  switch Js.String.match_(Js.Re.fromStringWithFlags("\\S", ~flags="g"), text) {
  | None => ""
  | Some(arr) => Js.String.slice(~from=0, ~to_=limit, Js.Array.joinWith("", arr))
  }

let checkNumber = (~text, ~limit) =>
  switch Js.String.match_(Js.Re.fromStringWithFlags("\\d", ~flags="g"), text) {
  | None => ""
  | Some(arr) => Js.String.slice(~from=0, ~to_=limit, Js.Array.joinWith("", arr))
  }

let isStringEmpty = str => str |> Js.String.length === 0 || str === "" || str === "-"

let stringNotEmpty = str => str |> isStringEmpty ? "-" : str

let matchOptionarrStrToStr = oparrStr =>
  switch oparrStr {
  | None => ""
  | Some(arr) => MapOption.mapOptStr(Belt.Array.get(arr, 0))
  }

let mapOptionarrOptStrToStr = (oparrOptStr: option<array<option<string>>>) => {
  switch oparrOptStr {
  | None => ""
  | Some(arrOptStr) => MapOption.mapOptOptStr(Belt.Array.get(arrOptStr, 0))
  }
}

let searchCaseInsensitive = (searchKeyword, fullText) => {
  let onlyWord = mapOptionarrOptStrToStr(
    Js.String.match_(Js.Re.fromStringWithFlags("[\\w\\s*]+", ~flags="g"), searchKeyword),
  )
  let searchKeyLower = Js.String.toLowerCase(onlyWord)
  let fullTextLower = Js.String.toLowerCase(fullText)
  mapOptionarrOptStrToStr(
    Js.String.match_(Js.Re.fromStringWithFlags(searchKeyLower, ~flags="g"), fullTextLower),
  )
}

let floatOfString = text =>
  switch text |> float_of_string {
  | exception _ => 0.
  | number => number
  }

let percentToStr = number => {
  let floatString = Js.Float.toFixedWithPrecision(number, ~digits=1)
  let splitNumber = Js.String.split(".", floatString)
  let re = Js.Re.fromStringWithFlags("\\B(?=(\\d{3})+(?!\\d))", ~flags="g")
  let commaNumber = Js.String.replaceByRe(re, ",", splitNumber[0])

  commaNumber ++ "." ++ splitNumber[1] ++ "%"
}

let numberToStringMaxLength4 = (number: int): string => {
  let f = float_of_int(number)
  if number < 1000 {
    string_of_int(number)
  } else if number < 100000 {
    let toKeep = f /. 1000.
    Js.Float.toFixedWithPrecision(toKeep, ~digits=1) ++ "k"
  } else if number < 1000000 {
    let toKeep = f /. 1000.
    Js.Float.toFixedWithPrecision(toKeep, ~digits=0) ++ "k"
  } else if number < 10000000 {
    let toKeep = f /. 1000000.
    Js.Float.toFixedWithPrecision(toKeep, ~digits=1) ++ "m"
  } else {
    let toKeep = f /. 1000000.
    Js.Float.toFixedWithPrecision(toKeep, ~digits=0) ++ "m"
  }
}

let getSearchParameter = (parameter: string, queryString: string): option<string> => {
  let regex = Js.Re.fromStringWithFlags({`${parameter}=([^&#]*)`}, ~flags="g")
  let rawValue = Js.String.match_(regex, queryString)
  switch rawValue {
  | None => None
  | Some(arr) =>
    switch Js.String.replace({`${parameter}=`}, "", Js.Array.joinWith("", arr)) {
    | "" => None
    | x => Some(x)
    }
  }
}

module ContentEditable = {
  open! Webapi.Dom

  let spanIdKey = "data-autosuggest-span-id"

  let getChildNodesAsArray = element => {
    element->Element.childNodes->NodeList.toArray
  }

  let getSpanChildNodes = element => {
    element
    ->getChildNodesAsArray
    ->Belt.Array.keepMap(childNode => {
      if childNode->Node.nodeType == Webapi__Dom__Types.Element {
        Some(childNode)
      } else {
        None
      }
    })
  }

  let getSpansValueAsList = element => {
    element
    ->getSpanChildNodes
    ->Belt.Array.map(span => {
      span
      ->Element.ofNode
      ->Belt.Option.mapWithDefault("", element => {
        element->Element.outerHTML
      })
    })
  }

  let moveCursorToNextSibling = (nextSibling, ~selection) => {
    // Add extra whitespace to next latest span
    if nextSibling->Node.textContent->Js.String2.length <= 0 {
      nextSibling->Node.setTextContent("\u00A0")
    }

    let newRange = Document.createRange(document)
    newRange->Range.setStart(nextSibling, 1)
    newRange->Range.setEnd(nextSibling, 1)

    selection->Selection.removeAllRanges
    selection->Selection.addRange(newRange)
  }

  let replaceTriggerStringFromPreviousSibling = (
    ~replaceWith="",
    previousSibling,
    triggerRegex,
  ) => {
    previousSibling
    ->Node.textContent
    ->Js.String2.replaceByRe(triggerRegex, replaceWith)
    ->Node.setTextContent(previousSibling, _)
  }

  let insertSpanNode = (newText, ~spanId, ~selectionRange as currentRange) => {
    // Create new highlight Range to move newText Node to a span
    let span = document->Document.createElement("span")
    span->Element.setClassName("highlight")
    span->Element.setAttribute(spanIdKey, spanId)
    span->Element.setTextContent(newText)

    // Insert new text Node to selectionRange
    currentRange->Range.insertNode(span)
  }

  let insertNodeElement = (insertEl, ~spanId, ~selectionRange as currentRange) => {
    // Add attribute extra span id key
    insertEl->Element.setAttribute(spanIdKey, spanId)

    // Insert new text Node to selectionRange
    currentRange->Range.insertNode(insertEl)
  }

  let updateValue = (~divEl, ~triggerRegex, insertEl) => {
    window
    ->Window.getSelection
    ->Belt.Option.map(selection => {
      let selectionRange = selection->Selection.getRangeAt(0)
      let newSpanId = divEl->getSpanChildNodes->Belt.Array.length->Belt.Int.toString

      // Insert new text with style
      // We're not use `setInnerText` because `insertNode` will insert empty text node automatically
      insertEl->insertNodeElement(~selectionRange, ~spanId=newSpanId)

      // Get latest span to update cursor and remove trigger string
      let latestSpan =
        divEl
        ->getChildNodesAsArray
        ->Belt.Array.getBy(childNode => {
          if childNode->Node.nodeType == Webapi__Dom__Types.Element {
            switch childNode->Element.ofNode {
            | None => false
            | Some(childEl) => childEl->Element.getAttribute(spanIdKey) == Some(newSpanId)
            }
          } else {
            false
          }
        })

      // Move cursor to next sibling of latest span
      latestSpan
      ->Belt.Option.mapWithDefault(None, Node.nextSibling)
      ->Belt.Option.map(moveCursorToNextSibling(~selection))
      ->ignore

      // Remove trigger string from previous sibling of latest span
      latestSpan
      ->Belt.Option.mapWithDefault(None, Node.previousSibling)
      ->Belt.Option.map(replaceTriggerStringFromPreviousSibling(_, triggerRegex))
      ->ignore
    })
    ->ignore
  }
}
