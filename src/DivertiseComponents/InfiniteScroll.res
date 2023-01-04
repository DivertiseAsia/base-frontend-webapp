@react.component
let make = (
  ~isLoading: bool,
  ~isOutOfItems: bool,
  ~loadingComponent: React.element,
  ~endingComponent: React.element,
  ~children: React.element,
  ~onScrollDown: unit => unit,
  ~onScrollPercent: float,
) => {
  let (isReachedBottom, setIsReachedBottom) = React.useState(_ => false)
  let scrollContainerRef = React.useRef(Js.Nullable.null)

  React.useEffect(() => {
    let break = ref(false)

    if isLoading || isOutOfItems || break.contents {
      Some(_ => break := true)
    }
    else {
      let handleScroll = _e => {
        let (clientHeight, scrollHeight, scrollTop) = switch Js.Nullable.toOption(
          scrollContainerRef.current,
        ) {
        | None => (0., 0., 0.)
        | Some(element) => (
            Webapi.Dom.Element.clientHeight(element)->Belt.Int.toFloat,
            Webapi.Dom.Element.scrollHeight(element)->Belt.Int.toFloat,
            Webapi.Dom.Element.scrollTop(element),
          )
        }

        setIsReachedBottom(_ =>
          scrollHeight -. clientHeight *. (1. +. (1. -. onScrollPercent)) < scrollTop
        )

        if isReachedBottom {
          onScrollDown()
        }
      }

      let _ = switch Js.Nullable.toOption(scrollContainerRef.current) {
      | None => ()
      | Some(element) => Webapi.Dom.Element.addEventListener(element, "scroll", handleScroll)
      }

      Some(
        () => {
          let _ = switch Js.Nullable.toOption(scrollContainerRef.current) {
          | None => ()
          | Some(element) => Webapi.Dom.Element.removeEventListener(element, "scroll", handleScroll)
          }
        },
      )
    }
  })

  <div className="scroll-wrapper" style={ReactDOM.Style.make(~height="100vh", ())}>
    <section
      id="scroll-container"
      ref={ReactDOM.Ref.domRef(scrollContainerRef)}
      style={ReactDOM.Style.make(
        ~width="100%",
        ~height="100%",
        ~overflow="auto",
        ~position="relative",
        ~textAlign="center",
        (),
      )}>
      children
      {isLoading ? loadingComponent : React.null}
      {isOutOfItems && !isLoading ? endingComponent : React.null}
    </section>
  </div>
}
