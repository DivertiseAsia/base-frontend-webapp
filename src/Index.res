/*
     This is an entry point file.
     Do not add anything here.
 */
@val external version: string = "BUILD.VERSION"
let appName = Config.Info.name
Js.log(`${appName}: ${version}`)

switch ReactDOM.querySelector("#app") {
| Some(root) => ReactDOM.render(<App />, root)
| None => () // do nothing
}
