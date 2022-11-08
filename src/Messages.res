open ReactIntl

module HelloWorld = {
  @@intl.messages
  let hello = {id: "helloworld.hello", defaultMessage: "Hello {name}!"}
}

module Global = {
  @@intl.messages
  let loading = {id: "global.loading", defaultMessage: "Loading"}
}

module NotFound = {
  @@intl.messages
  let header = {id: "notfound.header", defaultMessage: "404 - Page Not Found"}
}

module Auth = {
  @@intl.messages
  let login = {id: "auth.login", defaultMessage: "Log In"}
  let logout = {id: "auth.logout", defaultMessage: "Logout"}
  let register = {id: "auth.register", defaultMessage: "Register"}
  let forgotPassword = {id: "auth.forgotPassword", defaultMessage: "Forgot Password"}

  let password = {id: "auth.password", defaultMessage: "Password"}
  let confirmPassword = {id: "auth.confirmPassword", defaultMessage: "Confirm Password"}
  let email = {id: "auth.email", defaultMessage: "Email"}
  let warningEmailNotBlank = {
    id: "auth.warningEmailNotBlank",
    defaultMessage: "Email must not be blank",
  }
  let sendMeAReset = {id: "auth.sendMeAReset", defaultMessage: "Send Reset Email"}
  let warningPasswordNotBlank = {
    id: "auth.warningPasswordNotBlank",
    defaultMessage: "Password must not be blank",
  }
  let loginSuccess = {id: "auth.loginSuccess", defaultMessage: "Login Success"}
  let registerSuccess = {id: "auth.registerSuccess", defaultMessage: "Register Success"}
  let resetSuccess = {id: "auth.resetSuccess", defaultMessage: "Reset Success"}
  let changePassword = {id: "auth.changePassword", defaultMessage: "Change Password"}
  let changePasswordSuccess = {
    id: "auth.changePasswordSuccess",
    defaultMessage: "Change Password Success",
  }
  let termsAgree = {id: "auth.termsAgree", defaultMessage: "Agree to terms & conditions"}
}
