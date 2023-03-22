type rowComponentProps<'a> = {
  data: array<'a>,
  dataIndex: int,
  dataEndIndex: int,
  top: float,
  height: float,
  row: int,
  column: int,
}

@react.component @module("react-recycled-list")
external make: (
  ~data: array<'data>,
  ~rowComponent: React.component<rowComponentProps<'a>>,
  ~rowHeight: float,
) => React.element = "FullWindowFixedList"
