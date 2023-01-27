@react.component
let make = () => {
  <div>
    <h1> {"Auto Suggestion Component"->React.string} </h1>
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
      /* 
        If isSyntaxHighlight is *false*, it will use <input />
        but if isSyntaxHighlight is *true*, it will use <div contentEditable=true />
      */
      isSyntaxHighlight=true
    />
  </div>
}
