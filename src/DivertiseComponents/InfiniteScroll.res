@react.component
let make = (~delay=2000: int, ~children: React.element) => {
  let scrollContainerRef = React.useRef(Js.Nullable.null)

  React.useEffect(() => {
    if isLoading && !isShown {
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

      let reachedBottom = scrollHeight -. clientHeight *. 1.2 <= scrollTop +. 1.
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

  // <div className="scroll-wrapper" style={ReactDOM.Style.make(~height="100vh", ())}>
  //   <section
  //     id="scroll-container"
  //     ref={ReactDOM.Ref.domRef(scrollContainerRef)}
  //     style={ReactDOM.Style.make(
  //       ~width="100%",
  //       ~height="100%",
  //       ~overflow="auto",
  //       ~position="relative",
  //       (),
  //     )}>
  //     cardsList
  //   loadingComponent
  //   </section>
  // </div>
}