let generateData = (amount: int): array<React.element> => {
  Belt.List.makeBy(amount, i => i + 1)
  ->Belt.List.mapWithIndex((index, _) => `index ${(index + 1)->Belt.Int.toString}`->React.string)
  ->Belt.List.toArray
}

let randomRowHeights = (data: array<React.element>, ~column: int=1, ()): array<float> => {
  Belt.List.makeBy(data->Js.Array2.length / column, i => i + 1)
  ->Belt.List.map(_ => Js.Math.random_int(60, 140)->Belt.Int.toFloat)
  ->Belt.List.toArray
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
    rowHeights={randomRowHeights(data, ())}
    rowComponent={Row.SimpleRow.make}
    data
    rowHeight=80.0
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

let variableListGrid = () => {
  let data = generateData(1000)

  <ReactRecycledList.VariableList
    height=500.0
    rowHeights={randomRowHeights(data, ~column=4, ())}
    rowComponent={Row.Grid.make}
    data
    rowHeight=80.0
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

let fullWindowVariableListSimpleRow = () => {
  let data = generateData(1000)

  <ReactRecycledList.FullWindowVariableList
    rowComponent={Row.SimpleRow.make}
    rowHeights={randomRowHeights(data, ())}
    data
    rowHeight=80.0
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

let fullWindowVariableListGrid = () => {
  let data = generateData(1000)

  <ReactRecycledList.FullWindowVariableList
    rowComponent={Row.Grid.make}
    data
    rowHeights={randomRowHeights(data, ())}
    rowHeight=80.0
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

let responsiveContainerDemo = () => {
  let renderList = ({width, height}: ReactRecycledList.dimension) => {
    let column = width > 1200.0 ? 2 : 1

    <ReactRecycledList.FixedList
      height
      rowComponent={Row.Grid.make}
      data={generateData(1000)}
      rowHeight=100.0
      column
      onVisibleRowChange={({
        firstVisibleRowIndex,
        firstVisibleDataIndex,
        lastVisibleRowIndex,
        lastVisibleDataIndex,
        lastRowIndex,
      }) => ()}
    />
  }

  <div style={ReactDOM.Style.make(~width="100%", ~height="50vh", ())}>
    <ReactRecycledList.ResponsiveContainer render={renderList} />
  </div>
}

let responsiveCustomWindowDemo = () => {
  let renderList = ({width, height}: ReactRecycledList.dimension) => {
    let column = width > 1200.0 ? 2 : 1

    <ReactRecycledList.FullWindowFixedList
      rowComponent={Row.Grid.make}
      data={generateData(1000)}
      rowHeight=100.0
      column
      onVisibleRowChange={({
        firstVisibleRowIndex,
        firstVisibleDataIndex,
        lastVisibleRowIndex,
        lastVisibleDataIndex,
        lastRowIndex,
      }) => ()}
    />
  }

  <ReactRecycledList.ResponsiveWindowContainer render={renderList} />
}

@react.component
let make = () => {
  <>
    <h1> {"React recycled list"->React.string} </h1>
    {fixedListSimpleRow()}
    {fixedListGrid()}
    {variableListSimpleRow()}
    {variableListGrid()}
    {fullWindowFixedListSimpleRow()}
    {fullWindowFixedListGrid()}
    {fullWindowVariableListSimpleRow()}
    {fullWindowVariableListGrid()}
    {responsiveContainerDemo()}
    {responsiveCustomWindowDemo()}
  </>
}
