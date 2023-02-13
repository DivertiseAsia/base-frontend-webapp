@react.component
let make = () => {
  let namesList = list{"Alice", "Tata", "Bob", "Charlie", "Alex", "Robert", "Robson"}
  let emailsList = list{
    "alice@gmail.com",
    "tata@gmail.com",
    "bob@gmail.com",
    "charlie@yahoo.com",
    "alex@gmail.com",
    "robert@hotmail.com",
    "robson@gmail.com",
  }

  <div className="center-wrapper">
    <h1> {"Auto Suggestion Component"->React.string} </h1>
    <p>
      {"make an auto-suggestion with trigger to suggest by 'symbol' or 'regex'."->React.string}
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
              {" : you can send to trigger by variant `TriggerSymbol` or `TriggerRegex`."->React.string}
              {Utils.createUnorderedList([
                <code> {`triggerBy: TriggerSymbol("@")`->React.string} </code>,
                <code>
                  {`triggerBy: TriggerRegex("^@(\\w*)|\\s@(\\w*)"->Js.Re.fromStringWithFlags(~flags="ig"))`->React.string}
                </code>,
              ])}
            </>,
            <>
              <b> {"triggerOptions"->React.string} </b>
              {" : a list that contain triggered contents that can be in form of `lists of string` or `list of React components`"->React.string}
              {Utils.createUnorderedList([
                <pre>
                  <code>
                    {`triggerOptions: OptionText(list{"Alice", "Tata", "Bob", "Charlie", "Alex", "Robert", "Robson"})`->React.string}
                  </code>
                </pre>,
                <pre>
                  <code>
                    {`triggerOptions: OptionComponent(list{
  {
    component: <DemoOption className="option-1" name="Alice" email="alice@gmail.com" />,
    optionValue: "alice",
  },
  {
    component: <DemoOption className="option-2" name="Tata" email="tata@gmail.com" />,
    optionValue: "tata",
  },
  {
    component: <DemoOption className="option-3" name="Bob" email="bob@gmail.com" />,
    optionValue: "bob",
  },
  {
    component: <DemoOption className="option-4" name="Charlie" email="charlie@yahoo.com" />,
    optionValue: "charlie",
  },
})`->React.string}
                  </code>
                </pre>,
              ])}
            </>,
            <>
              <b> {"suggestion"->React.string} </b>
              {" : add normal `span` or `React component` into a text box when choose option."->React.string}
              {Utils.createUnorderedList([
                <code>
                  {`suggestion: SuggestedSpan(Some("color:#DC143C;font-weight:bold;text-decoration:underline;"))`->React.string}
                </code>,
                <code> {`suggestion: SuggestedSpan(None)`->React.string} </code>,
                <code>
                  {`suggestion: SuggestedComponent(name => <DemoSuggestion className="suggestion" name />)`->React.string}
                </code>,
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
      triggerOptions: OptionText(list{"Alice", "Tata", "Bob", "Charlie", "Alex", "Robert", "Robson"}),
      suggestion: SuggestedSpan(None),
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
                triggerOptions: OptionText(namesList),
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
      triggerOptions: OptionText(list{
        "alice@gmail.com",
        "tata@gmail.com",
        "bob@gmail.com",
        "charlie@yahoo.com",
        "alex@gmail.com",
        "robert@hotmail.com",
        "robson@gmail.com",
      }),
      suggestion: SuggestedSpan(
        Some("color:#DC143C;font-weight:bold;text-decoration:underline;"),
      ),
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
                triggerOptions: OptionText(emailsList),
                suggestion: SuggestedSpan(
                  Some("color:#DC143C;font-weight:bold;text-decoration:underline;"),
                ),
              },
            }
          />
        </>,
        <>
          <p> {"Auto-suggestion component trigger with '@' or 'Regex(!) that contain data of name and E-mail list'"->React.string} </p>
          <pre>
            <code>
              {`<AutoSuggestion
  triggers=list{
    {
      triggerBy: TriggerSymbol("@"),
      triggerOptions: OptionText(list{"Alice", "Tata", "Bob", "Charlie", "Alex", "Robert", "Robson"}),
      suggestion: SuggestedSpan(
        Some("color:#362FD9;font-weight:bold;font-style:italic;"),
      ),
    },
    {
      triggerBy: TriggerRegex(
        "^!(\\\\w*)|\\\\s!(\\\\w*)"->Js.Re.fromStringWithFlags(~flags="ig"),
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
      suggestion: SuggestedSpan(
        Some("color:#DC143C;font-weight:bold;text-decoration:underline;"),
      ),
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
                triggerOptions: OptionText(namesList),
                suggestion: SuggestedSpan(
                  Some("color:#362FD9;font-weight:bold;font-style:italic;"),
                ),
              },
              {
                triggerBy: TriggerRegex(
                  "^!(\\w*)|\\s!(\\w*)"->Js.Re.fromStringWithFlags(~flags="ig"),
                ),
                triggerOptions: OptionText(emailsList),
                suggestion: SuggestedSpan(
                  Some("color:#DC143C;font-weight:bold;text-decoration:underline;"),
                ),
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
      triggerBy: TriggerRegex("^!(\\w*)|\\s!(\\w*)"->Js.Re.fromStringWithFlags(~flags="ig")),
      triggerOptions: OptionComponent(list{
        {
          component: <DemoOption className="option-1" name="Alice" email="alice@gmail.com" />,
          optionValue: "alice",
        },
        {
          component: <DemoOption className="option-2" name="Tata" email="tata@gmail.com" />,
          optionValue: "tata",
        },
        {
          component: <DemoOption className="option-3" name="Bob" email="bob@gmail.com" />,
          optionValue: "bob",
        },
        {
          component: <DemoOption className="option-4" name="Charlie" email="charlie@yahoo.com" />,
          optionValue: "charlie",
        },
        {
          component: <DemoOption className="option-5" name="Alex" email="alex@gmail.com" />,
          optionValue: "alex",
        },
        {
          component: <DemoOption className="option-6" name="Robert" email="robert@hotmail.com" />,
          optionValue: "robert",
        },
        {
          component: <DemoOption className="option-7" name="Robson" email="robson@gmail.com" />,
          optionValue: "robson",
        },
        {
          component: <DemoOption className="option-8" name="Ronaldo" email="ronaldo@gmail.com" />,
          optionValue: "ronaldo",
        },
      }),
      suggestion: SuggestedComponent(name => <DemoSuggestion className="suggestion" name />),
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
                triggerOptions: OptionComponent(list{
                  {
                    component: <DemoOption
                      className="option-1" name="Alice" email="alice@gmail.com"
                    />,
                    optionValue: "alice",
                  },
                  {
                    component: <DemoOption
                      className="option-2" name="Tata" email="tata@gmail.com"
                    />,
                    optionValue: "tata",
                  },
                  {
                    component: <DemoOption className="option-3" name="Bob" email="bob@gmail.com" />,
                    optionValue: "bob",
                  },
                  {
                    component: <DemoOption
                      className="option-4" name="Charlie" email="charlie@yahoo.com"
                    />,
                    optionValue: "charlie",
                  },
                  {
                    component: <DemoOption
                      className="option-5" name="Alex" email="alex@gmail.com"
                    />,
                    optionValue: "alex",
                  },
                  {
                    component: <DemoOption
                      className="option-6" name="Robert" email="robert@hotmail.com"
                    />,
                    optionValue: "robert",
                  },
                  {
                    component: <DemoOption
                      className="option-7" name="Robson" email="robson@gmail.com"
                    />,
                    optionValue: "robson",
                  },
                  {
                    component: <DemoOption
                      className="option-8" name="Ronaldo" email="ronaldo@gmail.com"
                    />,
                    optionValue: "ronaldo",
                  },
                }),
                suggestion: SuggestedComponent(
                  name => <DemoSuggestion className="suggestion" name />,
                ),
              },
            }
          />
        </>,
      ])}
    </div>
  </div>
}
