type t = Js.Date.t

@send
external toLocaleDateStringWithOption: (t, @as("en-GB") _, {..}) => string = "toLocaleDateString"

@send
external toLocaleTimeStringWithOption: (t, @as("en-GB") _, {..}) => string = "toLocaleTimeString"

@send
external toLocaleTimeString: (
  t,
  @as("en-GB") _,
  @as(json`{"hour": "2-digit", "minute": "2-digit"}`) _,
) => string = "toLocaleTimeString"
