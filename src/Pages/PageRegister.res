@react.component
let make = (~queryString: string) => {
  let email = Js.Option.getWithDefault("", Utils.getSearchParameter("email", queryString))
  let first_name = Js.Option.getWithDefault("", Utils.getSearchParameter("first_name", queryString))
  let last_name = Js.Option.getWithDefault("", Utils.getSearchParameter("last_name", queryString))
  <div>
    <RegisterContainer defaultEmail=email defaultFirstName=first_name defaultLastName=last_name />
    <Link href=Links.login> <IntlMessage message=Messages.Auth.login /> </Link>
  </div>
}
