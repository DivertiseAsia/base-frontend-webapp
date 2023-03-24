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
    onVisibleRowChange={({
      firstVisibleRowIndex: _,
      firstVisibleDataIndex: _,
      lastVisibleRowIndex: _,
      lastVisibleDataIndex: _,
      lastRowIndex: _,
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
      firstVisibleRowIndex: _,
      firstVisibleDataIndex: _,
      lastVisibleRowIndex: _,
      lastVisibleDataIndex: _,
      lastRowIndex: _,
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
    onVisibleRowChange={({
      firstVisibleRowIndex: _,
      firstVisibleDataIndex: _,
      lastVisibleRowIndex: _,
      lastVisibleDataIndex: _,
      lastRowIndex: _,
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
      firstVisibleRowIndex: _,
      firstVisibleDataIndex: _,
      lastVisibleRowIndex: _,
      lastVisibleDataIndex: _,
      lastRowIndex: _,
    }) => ()}
  />
}

let fullWindowFixedListSimpleRow = () => {
  <ReactRecycledList.FullWindowFixedList
    rowComponent={Row.SimpleRow.make}
    data={generateData(1000)}
    rowHeight=100.0
    onVisibleRowChange={({
      firstVisibleRowIndex: _,
      firstVisibleDataIndex: _,
      lastVisibleRowIndex: _,
      lastVisibleDataIndex: _,
      lastRowIndex: _,
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
      firstVisibleRowIndex: _,
      firstVisibleDataIndex: _,
      lastVisibleRowIndex: _,
      lastVisibleDataIndex: _,
      lastRowIndex: _,
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
        firstVisibleRowIndex: _,
        firstVisibleDataIndex: _,
        lastVisibleRowIndex: _,
        lastVisibleDataIndex: _,
        lastRowIndex: _,
      }) => ()}
    />
  }

  <div style={ReactDOM.Style.make(~width="100%", ~height="50vh", ())}>
    <ReactRecycledList.ResponsiveContainer render={renderList} />
  </div>
}

let responsiveCustomWindowDemo = () => {
  let renderList = ({width, height: _}: ReactRecycledList.dimension) => {
    let column = width > 1200.0 ? 2 : 1

    <ReactRecycledList.FullWindowFixedList
      rowComponent={Row.Grid.make}
      data={generateData(1000)}
      rowHeight=100.0
      column
      onVisibleRowChange={({
        firstVisibleRowIndex: _,
        firstVisibleDataIndex: _,
        lastVisibleRowIndex: _,
        lastVisibleDataIndex: _,
        lastRowIndex: _,
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
    {responsiveContainerDemo()}
    {responsiveCustomWindowDemo()}
  </>
}
