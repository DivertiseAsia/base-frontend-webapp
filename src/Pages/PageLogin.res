@react.component
let make = (~queryString: string) => {
  let email = Js.Option.getWithDefault("", Utils.getSearchParameter("email", queryString))
  <div>
    <LoginContainer defaultEmail=email />
    <Link href=Links.forgot>
      <IntlMessage message=Messages.Auth.forgotPassword />
    </Link>
    <Link href=Links.register>
      <IntlMessage message=Messages.Auth.register />
    </Link>
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
          highlightStyle: Some("color:#DC143C;font-weight:bold;text-decoration:underline;"),
        },
      }
      /* If isSyntaxHighlight is *true*, it will use <input />
         but if isSyntaxHighlight is *false*, it will use <div contentEditable=true />
      */
      isSyntaxHighlight=true
    />
  </div>
}
