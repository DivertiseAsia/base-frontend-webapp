@react.component
let make = (~queryString: string) => {
  let email = Js.Option.getWithDefault("", Utils.getSearchParameter("email", queryString))
  <div>
    <LoginContainer defaultEmail=email />
    <Link href=Links.forgot> <IntlMessage message=Messages.Auth.forgotPassword /> </Link>
    <Link href=Links.register> <IntlMessage message=Messages.Auth.register /> </Link>
  </div>
}
