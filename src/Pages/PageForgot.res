@react.component
let make = (~queryString: string) => {
  let email = Js.Option.getWithDefault("", Utils.getSearchParameter("email", queryString))
  <div>
    <ForgotContainer defaultEmail=email />
    <Link href=Links.login> <IntlMessage message=Messages.Auth.login /> </Link>
    <Link href=Links.register> <IntlMessage message=Messages.Auth.register /> </Link>
  </div>
}
