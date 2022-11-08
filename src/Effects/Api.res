@val external _server: string = "API_SERVER"

let baseUrl = _server ++ "/api/"

/* let requestSomethingsPath = `${baseUrl}/something/`; */

let requestProfilePath = `${baseUrl}v1/profile/me/`

let requestRegisterPath = `${baseUrl}v1/auth/register/`
let requestLoginPath = `${baseUrl}v1/auth/login/`
let requestChangePasswordPath = `${baseUrl}v1/auth/password/`
let requestResetPasswordPath = `${baseUrl}v1/auth/password_reset/`
let requestResetPasswordConfirmPath = `${baseUrl}v1/auth/password_reset/confirm/`

let getProfile = (~token: string, ~callback: WebData.apiAction<User.profile> => unit) => {
  RequestUtils.requestJsonResponseToAction(
    ~headers=RequestUtils.buildHeader(~verb=Get, Some(token)),
    ~url=requestProfilePath,
    ~successAction=json => {
      let profile = RequestUtils.decode(json, User.Profile.decode)
      switch profile {
      | Some(profile) => callback(WebData.RequestSuccess(profile))
      | None => callback(WebData.RequestError(""))
      }
    },
    ~failAction=json => {
      User.clearToken()
      callback(WebData.RequestError(Utils.getResponseMsgFromJson(json)))
    },
  )
}
