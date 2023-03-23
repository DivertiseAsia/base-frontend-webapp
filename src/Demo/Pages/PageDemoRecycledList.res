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
    onVisibleRowChange={({
      firstVisibleRowIndex,
      firstVisibleDataIndex,
      lastVisibleRowIndex,
      lastVisibleDataIndex,
      lastRowIndex,
    }) =>
      Js.logMany([
        firstVisibleRowIndex,
        firstVisibleDataIndex,
        lastVisibleRowIndex,
        lastVisibleDataIndex,
        lastRowIndex,
      ])}
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
    onVisibleRowChange={({
      firstVisibleRowIndex,
      firstVisibleDataIndex,
      lastVisibleRowIndex,
      lastVisibleDataIndex,
      lastRowIndex,
    }) =>
      Js.logMany([
        firstVisibleRowIndex,
        firstVisibleDataIndex,
        lastVisibleRowIndex,
        lastVisibleDataIndex,
        lastRowIndex,
      ])}
  />
}

let variableListSimpleRow = () => {
  let data =
    Belt.List.makeBy(1000, i => i + 1)->Belt.List.mapWithIndex((index, _) =>
      `index ${index->Belt.Int.toString}`->React.string
    )

  let rowHeights =
    data
    ->Belt.List.mapWithIndex((_, _) => Js.Math.random_int(60, 140)->Belt.Int.toFloat)
    ->Belt.List.toArray

  <ReactRecycledList.VariableList
    height=500.0
    rowHeights
    rowComponent={Row.Grid.make}
    data={data->Belt.List.toArray}
    rowHeight=100.0
    onVisibleRowChange={({
      firstVisibleRowIndex,
      firstVisibleDataIndex,
      lastVisibleRowIndex,
      lastVisibleDataIndex,
      lastRowIndex,
    }) =>
      Js.logMany([
        firstVisibleRowIndex,
        firstVisibleDataIndex,
        lastVisibleRowIndex,
        lastVisibleDataIndex,
        lastRowIndex,
      ])}
  />
}

let fullWindowFixedListSimpleRow = () => {
  let data =
    Belt.List.makeBy(1000, i => i + 1)->Belt.List.mapWithIndex((index, _) =>
      `index ${index->Belt.Int.toString}`->React.string
    )

  <ReactRecycledList.FullWindowFixedList
    rowComponent={Row.Grid.make}
    data={data->Belt.List.toArray}
    rowHeight=100.0
    column=1
    onVisibleRowChange={({
      firstVisibleRowIndex,
      firstVisibleDataIndex,
      lastVisibleRowIndex,
      lastVisibleDataIndex,
      lastRowIndex,
    }) =>
      Js.logMany([
        firstVisibleRowIndex,
        firstVisibleDataIndex,
        lastVisibleRowIndex,
        lastVisibleDataIndex,
        lastRowIndex,
      ])}
  />
}

let fullWindowFixedListGrid = () => {
  let data =
    Belt.List.makeBy(1000, i => i + 1)->Belt.List.mapWithIndex((index, _) =>
      `index ${index->Belt.Int.toString}`->React.string
    )

  <ReactRecycledList.FullWindowFixedList
    rowComponent={Row.Grid.make}
    data={data->Belt.List.toArray}
    rowHeight=100.0
    column=4
    onVisibleRowChange={({
      firstVisibleRowIndex,
      firstVisibleDataIndex,
      lastVisibleRowIndex,
      lastVisibleDataIndex,
      lastRowIndex,
    }) =>
      Js.logMany([
        firstVisibleRowIndex,
        firstVisibleDataIndex,
        lastVisibleRowIndex,
        lastVisibleDataIndex,
        lastRowIndex,
      ])}
  />
}

@react.component
let make = () => {
  <>
    {fixedListSimpleRow()}
    //{fixedListGrid()}
    //{variableListSimpleRow()}
    //{fullWindowFixedListSimpleRow()}
    //{fullWindowFixedListGrid()}
  </>
}
