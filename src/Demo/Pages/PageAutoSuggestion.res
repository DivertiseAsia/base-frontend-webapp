@react.component
let make = () => {
  <div className="center-wrapper">
    <h1> {"Auto Suggestion Component"->React.string} </h1>
    <p>
      {"make an auto-suggestion with trigger to suggest with 'symbol' or 'regex'."->React.string}
    </p>
    <div className="props">
      <h2> {"Props of component"->React.string} </h2>
      {Utils.createUnorderedList([
        <>
          <b> {"triggers"->React.string} </b>
          {" : a record that contain one or more contents to trigger."->React.string}
          {Utils.createUnorderedList([
            <>
              <b> {"triggerBy"->React.string} </b>
              {" : you can send to trigger by variant `symbol` or `Regex`."->React.string}
              {Utils.createUnorderedList([
                <code> {`triggerBy: TriggerSymbol("@")`->React.string} </code>,
                <code>
                  {`triggerBy: TriggerRegex("^@(\\w*)|\\s@(\\w*)"->Js.Re.fromStringWithFlags(~flags="ig"))`->React.string}
                </code>,
              ])}
            </>,
            <>
              <b> {"triggerOptions"->React.string} </b>
              {" : a list that contain suggested content."->React.string}
              {Utils.createUnorderedList([
                <code>
                  {`triggerOptions: list{"Alice", "Tata", "Bob", "Charlie", "Alex", "Robert", "Robson"}`->React.string}
                </code>,
              ])}
            </>,
            <>
              <b> {"highlightStyle"->React.string} </b>
              {" : option<string> type that depend on you if you want to style or not."->React.string}
              {Utils.createUnorderedList([
                <code>
                  {`highlightStyle: Some("color:#DC143C;font-weight:bold;text-decoration:underline;")`->React.string}
                </code>,
                <code> {"highlightStyle: None"->React.string} </code>,
              ])}
            </>,
          ])}
        </>,
      ])}
    </div>
    <div className="showcase">
      <h2> {"Showcase of component"->React.string} </h2>
      {Utils.createOrderedList([
        <>
          <p> {"Auto-suggestion component with no style and trigger with '@'"->React.string} </p>
          <pre>
            <code>
              {`<AutoSuggestion
  triggers=list{
    {
      triggerBy: TriggerSymbol("@"),
      triggerOptions: list{"Alice", "Tata", "Bob", "Charlie", "Alex", "Robert", "Robson"},
      highlightStyle: None,
    },
  }
/>
`->React.string}
            </code>
          </pre>
          <AutoSuggestion
            triggers=list{
              {
                triggerBy: TriggerSymbol("@"),
                triggerOptions: OptionText(list{
                  "Alice",
                  "Tata",
                  "Bob",
                  "Charlie",
                  "Alex",
                  "Robert",
                  "Robson",
                }),
                suggestion: SuggestedSpan(None),
              },
            }
          />
        </>,
        <>
          <p>
            {"Auto-suggestion component with style and trigger with 'Regex(!)'"->React.string}
          </p>
          <pre>
            <code>
              {`<AutoSuggestion
  triggers=list{
    {
      triggerBy: TriggerRegex(
        "^!(\\\\w*)|\\\\s!(\\\\w*)"->Js.Re.fromStringWithFlags(~flags="ig"),
      ),
      triggerOptions: list{
        "alice@gmail.com",
        "tata@gmail.com",
        "bob@gmail.com",
        "charlie@yahoo.com",
        "alex@gmail.com",
        "robert@hotmail.com",
        "robson@gmail.com",
      },
      highlightStyle: Some("color:#DC143C;font-weight:bold;text-decoration:underline;"),
    },
  }
/>
`->React.string}
            </code>
          </pre>
          <AutoSuggestion
            triggers=list{
              {
                triggerBy: TriggerRegex(
                  "^!(\\w*)|\\s!(\\w*)"->Js.Re.fromStringWithFlags(~flags="ig"),
                ),
                triggerOptions: OptionText(list{
                  "alice@gmail.com",
                  "tata@gmail.com",
                  "bob@gmail.com",
                  "charlie@yahoo.com",
                  "alex@gmail.com",
                  "robert@hotmail.com",
                  "robson@gmail.com",
                }),
                suggestion: SuggestedSpan(Some("color:#DC143C;font-weight:bold;text-decoration:underline;")),
              },
            }
          />
        </>,
        <>
          <p> {"Auto-suggestion component trigger with '@' or 'Regex(!)'"->React.string} </p>
          <pre>
            <code>
              {`<AutoSuggestion
  triggers=list{
    {
      triggerBy: TriggerSymbol("@"),
      triggerOptions: list{"Alice", "Tata", "Bob", "Charlie", "Alex", "Robert", "Robson"},
      highlightStyle: Some("color:#567189;font-weight:bold;font-style:italic;"),
    },
    {
      triggerBy: TriggerRegex(
        "^!(\\\\w*)|\\\\s!(\\\\w*)"->Js.Re.fromStringWithFlags(~flags="ig"),
      ),
      triggerOptions: list{
        "alice@gmail.com",
        "tata@gmail.com",
        "bob@gmail.com",
        "charlie@yahoo.com",
        "alex@gmail.com",
        "robert@hotmail.com",
        "robson@gmail.com",
      },
      highlightStyle: Some("color:#DC143C;font-weight:bold;text-decoration:underline;"),
    },
  }
/>
`->React.string}
            </code>
          </pre>
          <AutoSuggestion
            triggers=list{
              {
                triggerBy: TriggerSymbol("@"),
                triggerOptions: OptionText(list{
                  "Alice",
                  "Tata",
                  "Bob",
                  "Charlie",
                  "Alex",
                  "Robert",
                  "Robson",
                }),
                suggestion: SuggestedSpan(Some("color:#567189;font-weight:bold;font-style:italic;")),
              },
              {
                triggerBy: TriggerRegex(
                  "^!(\\w*)|\\s!(\\w*)"->Js.Re.fromStringWithFlags(~flags="ig"),
                ),
                triggerOptions: OptionText(list{
                  "alice@gmail.com",
                  "tata@gmail.com",
                  "bob@gmail.com",
                  "charlie@yahoo.com",
                  "alex@gmail.com",
                  "robert@hotmail.com",
                  "robson@gmail.com",
                }),
                suggestion: SuggestedSpan(Some("color:#DC143C;font-weight:bold;text-decoration:underline;")),
              },
            }
          />
        </>,
        <>
          <p>
            {"Auto-suggestion component with style and trigger with 'Regex(!)'"->React.string}
          </p>
          <AutoSuggestion
            triggers=list{
              {
                triggerBy: TriggerRegex(
                  "^!(\\w*)|\\s!(\\w*)"->Js.Re.fromStringWithFlags(~flags="ig"),
                ),
                triggerOptions: OptionComponent(list{
                  {component: <DemoOption className="option-1" name="Alice" email="alice@gmail.com" />, value: "alice"},
                  {component: <DemoOption className="option-2" name="Tata" email="tata@gmail.com" />, value: "tata"},
                  {component: <DemoOption className="option-3" name="Bob" email="bob@gmail.com" />, value: "bob"},
                  {component: <DemoOption className="option-4" name="Charlie" email="charlie@yahoo.com" />, value: "charlie"},
                  {component: <DemoOption className="option-5" name="Alex" email="alex@gmail.com" />, value: "alex"},
                  {component: <DemoOption className="option-6" name="Robert" email="robert@hotmail.com" />, value: "robert"},
                  {component: <DemoOption className="option-7" name="Robson" email="robson@gmail.com" />, value: "robson"},
                  {component: <DemoOption className="option-8" name="Ronaldo" email="ronaldo@gmail.com" />, value: "ronaldo"},
                }),
                suggestion: SuggestedSpan(Some("color:#DC143C;font-weight:bold;text-decoration:underline;")),
              },
            }
          />
        </>,
      ])}
    </div>
  </div>
}
