open AutoSuggestion

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
    // * : You can use either TriggerSymbol or TriggerRegex
      triggers=list{
        {
          trigger: TriggerSymbol("@"),
          // trigger: TriggerRegex("@(\\S+)|@"->Js.Re.fromStringWithFlags(~flags="ig"))
          triggerOptions: list{"Alice", "Tata", "Bob", "Charlie", "Alex", "Robert", "Robson"},
        },
        {
          trigger: TriggerSymbol("@"),
          // trigger: TriggerRegex("@(\\S+)|@"->Js.Re.fromStringWithFlags(~flags="ig"))
          triggerOptions: list{
            "alice@gmail.com",
            "tata@gmail.com",
            "bob@gmail.com",
            "charlie@yahoo.com",
            "alex@gmail.com",
            "robert@hotmail.com",
            "robson@gmail.com",
          },
        },
      }
      syntaxHighlight=true
    />
  </div>
}
