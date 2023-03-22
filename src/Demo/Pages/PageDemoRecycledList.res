let simpleListDemo = () => {
  let data =
    Belt.List.makeBy(1000, i => i + 1)->Belt.List.mapWithIndex((index, _) =>
      `index ${index->Belt.Int.toString}`->React.string
    )

  <RecycledList rowComponent={Row.make} data={data->Belt.List.toArray} rowHeight=20.0 />
}

@react.component
let make = () => {
  <div style={ReactDOM.Style.make(~height="500px", ~overflowY="auto", ~width="100%", ())}>
    {simpleListDemo()}
  </div>
}
