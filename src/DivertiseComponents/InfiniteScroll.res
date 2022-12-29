@react.component
let make = (
  ~isLoading: bool,
  ~isOutOfItems: bool,
  ~loadingComponent: React.element,
  ~children: React.element,
  ~onScrollDown: unit => unit,
  ~onScrollPercent: float,
) => {
  let scrollContainerRef = React.useRef(Js.Nullable.null)

  React.useEffect(() => {
    if (isLoading && !isOutOfItems) {
      ()
    }

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
      Js.logMany([clientHeight, scrollHeight, scrollTop])

      let reachedBottom = scrollHeight -. clientHeight *. (1. +. (1. -. onScrollPercent)) < scrollTop
      Js.log(reachedBottom)

      if reachedBottom {
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
        (),
      )}>
      children
      {isLoading ? loadingComponent : React.null}
    </section>
  </div>
}
