@react.component
let make = () => {
  <div>
    <h1> {"Auto Suggestion Component"->React.string} </h1>
    <p>
      {"make an auto-suggestion with trigger to suggest with 'symbol' or 'regex'."->React.string}
    </p>
    <ul>
      <li> {"isSyntaxHighlight = false : normal <input /> tag"->React.string} </li>
      <AutoSuggestion
        triggers=list{
          {
            triggerBy: TriggerSymbol("@"),
            triggerOptions: list{"Alice", "Tata", "Bob", "Charlie", "Alex", "Robert", "Robson"},
            highlightStyle: None,
          },
        }
      />
      <li> {"isSyntaxHighlight = true : use <div contentEditable=true /> tag"->React.string} </li>
      <AutoSuggestion
        triggers=list{
          {
            triggerBy: TriggerSymbol("@"),
            triggerOptions: list{"Alice", "Tata", "Bob", "Charlie", "Alex", "Robert", "Robson"},
            highlightStyle: Some("color:#986BEB;font-weight:bold;font-style:italic;"),
          },
        }
      />
    </ul>
    <AutoSuggestion
      triggers=list{
        {
          // * : You can use either TriggerSymbol or TriggerRegex
          triggerBy: TriggerSymbol("@"),
          // trigger: TriggerRegex("@([a-zA-Z0-9_]+)|@"->Js.Re.fromStringWithFlags(~flags="ig"))
          triggerOptions: list{"Alice", "Tata", "Bob", "Charlie", "Alex", "Robert", "Robson"},
          highlightStyle: Some("color:#986BEB;font-weight:bold;font-style:italic;"),
        },
        {
          triggerBy: TriggerSymbol("!"),
          triggerOptions: list{
            "alice@gmail.com",
            "tata@gmail.com",
            "bob@gmail.com",
            "charlie@yahoo.com",
            "alex@gmail.com",
            "robert@hotmail.com",
            "robson@gmail.com",
          },
          // highlightStyle: Some("color:#DC143C;font-weight:bold;text-decoration:underline;"),
          highlightStyle: None,
        },
      }
    />
  </div>
}
