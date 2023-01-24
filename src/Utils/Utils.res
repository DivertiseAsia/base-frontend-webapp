let preventDefault = e => ReactEvent.Mouse.preventDefault(e)

let preventDefaultForm = e => ReactEvent.Form.preventDefault(e)

let valueFromEvent = event => ReactEvent.Form.target(event)["value"]

let boolFromCheckbox = (event): bool => ReactEvent.Form.target(event)["checked"]

let saveToLocalStorage = (key, data) => Dom.Storage.setItem(key, data, Dom.Storage.localStorage)

let loadFromLocalStorage = key => Dom.Storage.getItem(key, Dom.Storage.localStorage)

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

module Dom = {
  let setCursorPos = %raw(`
  function setCursorPos(text) {
    let selection = window.getSelection();
    let selectionRange = selection.getRangeAt(0);

    let newEl = document.createElement("p")
    newEl.innerText = text;
    let nodeTextNewEl = newEl.childNodes[0]
    console.log("type newEl, ", typeof(newEl))
    console.log(" nodeTextNewEl, ", nodeTextNewEl)
    console.log(">> nodeTextNewEl.textContent: ", nodeTextNewEl.textContent,"end")

    selectionRange.insertNode(nodeTextNewEl);
    selectionRange.setStart(nodeTextNewEl, nodeTextNewEl.textContent.length);

    // let nextSibling = nodeTextNewEl.nextSibling
    // console.log(">>> nextSibling: ",  nextSibling)
    // selectionRange.selectNode(nextSibling)
    // selectionRange.setStart(nextSibling, 0);
    // selectionRange.setEnd(nextSibling, 0);

    /*
    The Range.surroundContents() method moves content of the Range into a new node, placing the new node at the start of the specified range.
    */
    let rangeHighlight = document.createRange()
    let newParent = document.createElement("span");
    newParent.style.color = "red"
    newParent.class = "highlight"
    newParent.setAttribute("data-autosuggest-span-id", "1")
    rangeHighlight.selectNode(nodeTextNewEl)
    // rangeHighlight.setStart(nodeTextNewEl, 0);
    rangeHighlight.surroundContents(newParent)


    // Set cursor post to end of range highlight
    // rangeHighlight.setStart(nodeTextNewEl, nodeTextNewEl.textContent.length);
    // rangeHighlight.setEnd(nodeTextNewEl, nodeTextNewEl.textContent.length);
    rangeHighlight.collapse(false);
    selection.removeAllRanges()
    selection.addRange(rangeHighlight)
    // let newAddedSpan = document.querySelector("[data-autosuggest-span-id=1]")


  console.log(">>>)) newEl.childNodes: ", newEl.childNodes)
  console.log(">>>)) nodeTextNewEl: ", nodeTextNewEl)
  console.log(">>>)) rangeHighlight: ", rangeHighlight)
  // console.log(">>>)) newAddedSpan.nextSibling: ", newAddedSpan.nextSibling)
  console.log(">>>)) selection.anchorNode: ", selection.anchorNode)
  console.log(">>>)) selection.anchorNode: ", selection.anchorNode.childNodes)
    // for (nextNode in selection.anchorNode.childNodes) {

    // }
    // rangeHighlight.insertNode(nextSibling)
    // rangeHighlight.selectNode(nextSibling)
    // rangeHighlight.collapse(false)

  }
  `)

  let testInsertNode = %raw(`
  function testInsertNode(){
    let range = document.createRange();
    let newNode = document.createElement("p");
    newNode.appendChild(document.createTextNode("New Node Inserted Here"));
    range.selectNode(document.getElementsByTagName("div").item(0));
    range.insertNode(newNode);

    }
    `)

  let spanToH1 = %raw(`
    function spanToH1(){
      const range = document.createRange();
      const newParent = document.createElement('h1');

      range.selectNode(document.querySelector('.header-text'));
      range.surroundContents(newParent);
    }`)
}

module ContentEditable = {
  open! Webapi.Dom

  let spanIdKey = "data-autosuggest-span-id"

  let getChildNodesFromSelectionAsArray = selection => {
    selection
    ->Selection.anchorNode
    ->Belt.Option.mapWithDefault([], anchorNode => {
      anchorNode->Node.childNodes->NodeList.toArray
    })
  }

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

  let moveCursorToNextSibling = (nextSibling, ~selection) => {
    // Add extra whitespace to next latest span
    if nextSibling->Node.textContent->Js.String2.length <= 0 {
      nextSibling->Node.setTextContent("\u00A0" ++ nextSibling->Node.textContent)
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

  let highlightNewText = (
    newTextNode,
    ~spanId,
    ~selectionRange as currentRange,
    ~selection as currentSelection,
  ) => {
    // Insert new text Node to selectionRange
    currentRange->Range.insertNode(newTextNode)
    currentRange->Range.setStart(newTextNode, newTextNode->Node.textContent->Js.String2.length)

    // Create new highlight Range to move newText Node to a span
    let highlightRange = Document.createRange(document) // TODO: rename HighlightRange
    let span = document->Document.createElement("span")
    span->Element.setClassName("highlight")
    span->Element.setAttribute(spanIdKey, spanId->Belt.Int.toString)

    highlightRange->Range.selectNode(newTextNode)
    highlightRange->Range.surroundContents(span)

    // Set cursor position to end of the end of highlight text
    highlightRange->Range.collapse
    currentSelection->Selection.removeAllRanges
    currentSelection->Selection.addRange(highlightRange)
  }

  let updateValue = (~divEl, newText, triggerRegex) => {
    window
    ->Window.getSelection
    ->Belt.Option.map(selection => {
      let selectionRange = selection->Selection.getRangeAt(0)
      let spanChildNodes = getSpanChildNodes(divEl)
      let newSpanId = spanChildNodes->Belt.Array.length

      // Create new paragraph element to be able to highlight the "newText"
      // We will remove it at the last step
      let newParagraphEl = document->Document.createElement("p")
      newParagraphEl->Element.setInnerText(newText)

      // Update paragraph text node and move it to div[contenteditable]
      newParagraphEl
      ->Element.childNodes
      ->NodeList.item(0)
      ->Belt.Option.map(newTextNode => {
        // Highlight new text
        newTextNode->highlightNewText(~selection, ~selectionRange, ~spanId=newSpanId)

        // Get latest span to update cursor and remove trigger string
        let latestSpan =
          divEl
          ->getChildNodesAsArray
          ->Belt.Array.getBy(
            childNode => {
              if childNode->Node.nodeType == Webapi__Dom__Types.Element {
                switch childNode->Element.ofNode {
                | None => false
                | Some(childEl) =>
                  childEl->Element.getAttribute(spanIdKey) == Some(newSpanId->Belt.Int.toString)
                }
              } else {
                false
              }
            },
          )

        Js.log2("!! latestSpan: ", latestSpan)

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

      //Clean orpan element
      newParagraphEl->Element.remove
    })
    ->ignore
  }
}
