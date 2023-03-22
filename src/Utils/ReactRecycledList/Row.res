module Row = {
  @react.component
  let make = React.memo((~data: array<'a>, ~dataIndex: int, ~top: float, ~height: float) => {
    let value = data[dataIndex]
    <div
      style={ReactDOM.Style.make(
        ~top={top->Belt.Float.toString},
        ~height={height->Belt.Float.toString},
        (),
      )}
      className="react-recycled-row">
      {value}
    </div>
  })
}

module MakeRow = {
  @react.component
  let make = (
    ~data: array<React.element>,
    ~dataIndex: int,
    ~top: float,
    ~height: float,
    ~rowHeight: float,
  ) => {
    <RecycledList
      rowComponent={Row.make({"data": data, "dataIndex": dataIndex, "top": top, "height": height})}
      data
      rowHeight
    />
  }
}

let simpleListDemo = () => {
  let data =
    Belt.List.makeBy(1000, i => i + 1)->Belt.List.mapWithIndex((index, _) =>
      `index ${index->Belt.Int.toString}`->React.string
    )

  data->Belt.List.mapWithIndex((index, _) =>
    <MakeRow data={data->Belt.List.toArray} dataIndex=index top=0.0 height=0.0 rowHeight=100.0 />
  )
}
