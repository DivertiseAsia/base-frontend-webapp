@react.component
let make = (~queryString: string) => {
  let token = Js.Option.getWithDefault("", Utils.getSearchParameter("token", queryString))

  <ResetPasswordConfirmContainer token />
}
