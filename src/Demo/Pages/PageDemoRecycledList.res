let generateData = (amount: int): array<React.element> => {
  Belt.List.makeBy(amount, i => i + 1)
  ->Belt.List.mapWithIndex((index, _) => `index ${index->Belt.Int.toString}`->React.string)
  ->Belt.List.toArray
}

let randomRowHeights = (data: array<React.element>): array<float> => {
  data->Js.Array2.mapi((_, _) => Js.Math.random_int(60, 140)->Belt.Int.toFloat)
}

let fixedListSimpleRow = () => {
  <ReactRecycledList.FixedList
    height=500.0
    rowComponent={Row.SimpleRow.make}
    data={generateData(1000)}
    rowHeight=100.0
    column=1
    onVisibleRowChange={({
      firstVisibleRowIndex,
      firstVisibleDataIndex,
      lastVisibleRowIndex,
      lastVisibleDataIndex,
      lastRowIndex,
    }) => ()}
  />
}

let fixedListGrid = () => {
  <ReactRecycledList.FixedList
    height=500.0
    rowComponent={Row.Grid.make}
    data={generateData(1000)}
    rowHeight=100.0
    column=4
    onVisibleRowChange={({
      firstVisibleRowIndex,
      firstVisibleDataIndex,
      lastVisibleRowIndex,
      lastVisibleDataIndex,
      lastRowIndex,
    }) => ()}
  />
}

let variableListSimpleRow = () => {
  let data = generateData(1000)

  <ReactRecycledList.VariableList
    height=500.0
    rowHeights={randomRowHeights(data)}
    rowComponent={Row.SimpleRow.make}
    data
    rowHeight=100.0
    onVisibleRowChange={({
      firstVisibleRowIndex,
      firstVisibleDataIndex,
      lastVisibleRowIndex,
      lastVisibleDataIndex,
      lastRowIndex,
    }) => ()}
  />
}

let fullWindowFixedListSimpleRow = () => {
  <ReactRecycledList.FullWindowFixedList
    rowComponent={Row.SimpleRow.make}
    data={generateData(1000)}
    rowHeight=100.0
    column=1
    onVisibleRowChange={({
      firstVisibleRowIndex,
      firstVisibleDataIndex,
      lastVisibleRowIndex,
      lastVisibleDataIndex,
      lastRowIndex,
    }) => ()}
  />
}

let fullWindowFixedListGrid = () => {
  <ReactRecycledList.FullWindowFixedList
    rowComponent={Row.Grid.make}
    data={generateData(1000)}
    rowHeight=100.0
    column=4
    onVisibleRowChange={({
      firstVisibleRowIndex,
      firstVisibleDataIndex,
      lastVisibleRowIndex,
      lastVisibleDataIndex,
      lastRowIndex,
    }) => ()}
  />
}

@react.component
let make = () => {
  <>
    // {fixedListSimpleRow()}
    // {fixedListGrid()}
    // {variableListSimpleRow()}
    // {fullWindowFixedListSimpleRow()}
    {fullWindowFixedListGrid()}
  </>
}
