@react.component
let make = (~user: User.profile) => {
  <div>
    <IntlMessage message=Messages.HelloWorld.hello values={"name": user.first_name} />
    <Link href=Links.logout> <IntlMessage message=Messages.Auth.logout /> </Link>
  </div>
}
