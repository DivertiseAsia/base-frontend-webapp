type props<'a> = RecycledList.rowComponentProps<'a>

let make = ({data, dataIndex, dataEndIndex, top, height, row, column}: props<'a>) => {
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
}
