@react.component
let make = (
  ~isLoading: bool=false,
  ~isOutOfItems: bool=false,
  ~loadingComponent: React.element=React.null,
  ~endingComponent: React.element=React.null,
  ~children: React.element,
  ~loadMoreItems: unit => unit,
  ~onScrollPercent: float=1.0,
) => {
  let scrollContainerRef = React.useRef(Js.Nullable.null)

  React.useEffect(() => {
    let break = ref(false)

    if isLoading || isOutOfItems || break.contents {
      Some(_ => break := true)
    } else {
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

        if scrollHeight -. clientHeight *. (1. +. (1. -. onScrollPercent)) < scrollTop {
          Js.log(
            "TODO: check if i keep scrolling fast - should not see this message until new items",
          )
          loadMoreItems()
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
    {switch (isLoading, isOutOfItems) {
    | (true, _) => loadingComponent
    | (false, true) => endingComponent
    | _ => React.null
    }}
  </section>
}
