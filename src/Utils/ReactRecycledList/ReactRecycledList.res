type rowComponentProps<'a> = {
  data: array<'a>,
  dataIndex: int,
  top: float,
  height: float,
}

module FullWindowFixedList = {
  @react.component @module("react-recycled-list")
  external make: (
    ~data: array<'data>,
    ~rowComponent: React.component<rowComponentProps<'a>>,
    ~rowHeight: float,
  ) => React.element = "FullWindowFixedList"
}

module FixedList = {
  @react.component @module("react-recycled-list")
  external make: (
    ~data: array<'data>,
    ~rowComponent: React.component<rowComponentProps<'a>>,
    ~rowHeight: float,
    ~height: float
  ) => React.element = "FixedList"
}
