let fullWindowFixedListSimpleRow = () => {
  let data =
    Belt.List.makeBy(1000, i => i + 1)->Belt.List.mapWithIndex((index, _) =>
      `index ${index->Belt.Int.toString}`->React.string
    )

  <ReactRecycledList.FullWindowFixedList
    rowComponent={Row.Grid.make} data={data->Belt.List.toArray} rowHeight=100.0 column=1
  />
}

let fixedListSimpleRow = () => {
  let data =
    Belt.List.makeBy(1000, i => i + 1)->Belt.List.mapWithIndex((index, _) =>
      `index ${index->Belt.Int.toString}`->React.string
    )

  <ReactRecycledList.FixedList
    height=500.0
    rowComponent={Row.Grid.make}
    data={data->Belt.List.toArray}
    rowHeight=100.0
    column=1
  />
}

let fullWindowFixedListGrid = () => {
  let data =
    Belt.List.makeBy(1000, i => i + 1)->Belt.List.mapWithIndex((index, _) =>
      `index ${index->Belt.Int.toString}`->React.string
    )

  <ReactRecycledList.FullWindowFixedList
    rowComponent={Row.Grid.make} data={data->Belt.List.toArray} rowHeight=100.0 column=4
  />
}

let fixedListGrid = () => {
  let data =
    Belt.List.makeBy(1000, i => i + 1)->Belt.List.mapWithIndex((index, _) =>
      `index ${index->Belt.Int.toString}`->React.string
    )

  <ReactRecycledList.FixedList
    height=500.0
    rowComponent={Row.Grid.make}
    data={data->Belt.List.toArray}
    rowHeight=100.0
    column=4
  />
}

@react.component
let make = () => {
  <>
    {fullWindowFixedListSimpleRow()}
    {fixedListSimpleRow()}
    {fullWindowFixedListGrid()}
    {fixedListGrid()}
  </>
}
