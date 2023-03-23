type props<'a> = ReactRecycledList.rowComponentProps<'a>

module SimpleRow = {
  let make = ({data, dataIndex, top, height}: props<'a>) => {
    let value = data[dataIndex]

    <div
      style={ReactDOM.Style.make(
        ~top={`${top->Belt.Float.toString}px`},
        ~height={`${height->Belt.Float.toString}px`},
        ~width="100%",
        ~position="absolute",
        ~display="flex",
        ~alignItems="center",
        ~justifyContent="center",
        (),
      )}
      className="react-recycled-row">
      {value}
    </div>
  }
}

module Grid = {
  let make = ({data, dataIndex, dataEndIndex, top, height, column}: props<'a>) => {
    let rowData = data->Js.Array2.slice(~start=dataIndex, ~end_=dataEndIndex)

    <div
      style={ReactDOM.Style.make(
        ~top=`${top->Belt.Float.toString}px`,
        ~height=`${height->Belt.Float.toString}px`,
        ~width="100%",
        ~position="absolute",
        ~display="flex",
        ~alignItems="center",
        (),
      )}
      className="react-recycled-row">
      {rowData
      ->Js.Array2.mapi((item, index) =>
        <div
          style={ReactDOM.Style.make(
            ~width=`${Belt.Int.toString(100 / column)}%`,
            ~textAlign="center",
            (),
          )}
          key={`item-${index->Belt.Int.toString}`}>
          {item}
        </div>
      )
      ->React.array}
    </div>
  }
}
