let simpleListDemo = () => {
  let data =
    Belt.List.makeBy(1000, i => i + 1)->Belt.List.mapWithIndex((index, _) =>
      `index ${index->Belt.Int.toString}`->React.string
    )

  <ReactRecycledList.FixedList
    height=300.0 rowComponent={Row.Grid.make} data={data->Belt.List.toArray} rowHeight=100.0 column=4
  />
}

@react.component
let make = () => {
  simpleListDemo()
}
