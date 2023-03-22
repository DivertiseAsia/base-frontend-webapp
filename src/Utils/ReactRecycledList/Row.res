type props<'a> = ReactRecycledList.rowComponentProps<'a>

let make = ({data, dataIndex, top, height}: props<'a>) => {
  let value = data[dataIndex]

  <div
    style={ReactDOM.Style.make(
      ~top={`${top->Belt.Float.toString}px`},
      ~height={`${height->Belt.Float.toString}px`},
      ~position="absolute",
      (),
    )}
    className="react-recycled-row">
    {value}
  </div>
}
