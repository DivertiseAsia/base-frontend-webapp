type rowComponentProps<'a> = {
  data: array<'a>,
  dataIndex: int,
  dataEndIndex: int,
  top: float,
  height: float,
  row: int,
  column: int,
}

type visibilityInfo = {
  firstVisibleRowIndex: int,
  firstVisibleDataIndex: int,
  lastVisibleRowIndex: int,
  lastVisibleDataIndex: int,
  lastRowIndex: int,
}

type dimension = {height: float, width: float}

module FixedList = {
  @react.component @module("react-recycled-list")
  external make: (
    ~data: array<'data>,
    ~rowComponent: React.component<rowComponentProps<'a>>,
    ~rowHeight: float,
    ~height: float,
    ~column: int,
    ~onVisibleRowChange: visibilityInfo => unit,
  ) => React.element = "FixedList"
}

module VariableList = {
  @react.component @module("react-recycled-list")
  external make: (
    ~data: array<'data>,
    ~rowHeights: array<float>,
    ~rowHeight: float,
    ~rowComponent: React.component<rowComponentProps<'a>>,
    ~height: float,
    ~column: int,
    ~onVisibleRowChange: visibilityInfo => unit,
  ) => React.element = "VariableList"
}

module FullWindowFixedList = {
  @react.component @module("react-recycled-list")
  external make: (
    ~data: array<'data>,
    ~rowComponent: React.component<rowComponentProps<'a>>,
    ~rowHeight: float,
    ~column: int,
    ~onVisibleRowChange: visibilityInfo => unit,
  ) => React.element = "FullWindowFixedList"
}

module FullWindowVariableList = {
  @react.component @module("react-recycled-list")
  external make: (
    ~data: array<'data>,
    ~rowComponent: React.component<rowComponentProps<'a>>,
    ~rowHeights: array<float>,
    ~rowHeight: float,
    ~column: int,
    ~onVisibleRowChange: visibilityInfo => unit,
  ) => React.element = "FullWindowVariableList"
}

module ResponsiveContainer = {
  @react.component @module("react-recycled-list")
  external make: (~render: dimension => React.element) => React.element = "ResponsiveContainer"
}

module ResponsiveWindowContainer = {
  @react.component @module("react-recycled-list")
  external make: (~render: dimension => React.element) => React.element = "ResponsiveWindowContainer"
}