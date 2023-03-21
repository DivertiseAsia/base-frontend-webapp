@react.component @module("react-recycled-list")
external make: (
  ~data: array<'data>,
  ~rowComponent: React.element,
  ~rowHeight: float,
) => React.element = "FullWindowFixedList"
