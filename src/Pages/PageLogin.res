open AutoSuggestion

@react.component
let make = (~queryString: string) => {
  let email = Js.Option.getWithDefault("", Utils.getSearchParameter("email", queryString))
  <div>
    <LoginContainer defaultEmail=email />
    <Link href=Links.forgot> <IntlMessage message=Messages.Auth.forgotPassword /> </Link>
    <Link href=Links.register> <IntlMessage message=Messages.Auth.register /> </Link>
    <AutoSuggestion
      // * : You can use either TriggerSymbol or TriggerRegex
      trigger=TriggerSymbol("@")
      // trigger=TriggerRegex("@(\\S+)|@"->Js.Re.fromStringWithFlags(~flags="ig"))
      triggerOptions=list{"Alice", "Tata", "Bob", "Charlie", "Alex", "Robert", "Robson"}
      syntaxHighlight=true
    />
  </div>
}
