@react.component
let make = (~delay=2000: int, ~children: React.element) => {
  let (isShown, setIsShown) = React.useState(_ => false)

  React.useEffect1(() => {
    let timer = Js.Global.setTimeout(() => setIsShown(_ => true), delay)

    Some(_ => Js.Global.clearTimeout(timer))
  }, [delay])


  isShown ? children : React.null
}