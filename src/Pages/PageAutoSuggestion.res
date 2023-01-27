@react.component
let make = () => {
  <div>
    <h1> {"Auto Suggestion Component"->React.string} </h1>
    <p>
      {"make an auto-suggestion with trigger to suggest with 'symbol' or 'regex'."->React.string}
    </p>
    <div className="props">
      <h2> {"Props of component"->React.string} </h2>
      <ul>
        <li>
          <b> {"triggers"->React.string} </b>
          {" : a record that contain one or more contents to trigger."->React.string}
        </li>
        <ul>
          <li>
            <p>
              <b> {"triggerBy"->React.string} </b>
              {" : you can send to trigger by `symbol` either `Regex` by variant type."->React.string}
            </p>
            <ul>
              <li>
                <code> {"triggerBy: TriggerSymbol(\"@\")"->React.string} </code>
              </li>
              <li>
                <code>
                  {"triggerBy: TriggerRegex(\"\\s@(\\w*)\"->Js.Re.fromStringWithFlags(~flags=\"ig\"))"->React.string}
                </code>
              </li>
              <br />
            </ul>
          </li>
          <li>
            <p>
              <b> {"triggerOptions"->React.string} </b>
              {" : a list that contain suggested content."->React.string}
            </p>
            <code>
              {"triggerOptions: list{\"Alice\", \"Tata\", \"Bob\", \"Charlie\", \"Alex\", \"Robert\", \"Robson\"}"->React.string}
            </code>
            <br />
            <br />
          </li>
          <li>
            <p>
              <b> {"highlightStyle"->React.string} </b>
              {" : option<string> type that depend on you if you want to style or not."->React.string}
            </p>
            <ul>
              <li>
                <code>
                  {"highlightStyle: Some(\"color:#DC143C;font-weight:bold;text-decoration:underline;\")"->React.string}
                </code>
              </li>
              <li>
                <code> {"highlightStyle: None"->React.string} </code>
              </li>
              <br />
            </ul>
          </li>
        </ul>
      </ul>
    </div>
    <AutoSuggestion
      triggers=list{
        {
          // * : You can use either TriggerSymbol or TriggerRegex
          triggerBy: TriggerSymbol("@"),
          // triggerBy: TriggerRegex("@([a-zA-Z0-9_]+)|@"->Js.Re.fromStringWithFlags(~flags="ig"))
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
