@react.component
let make = (
  ~href: string,
  ~className: option<string>=?,
  ~target: option<string>=?,
  ~isExternal: option<bool>=?,
  ~rel: option<string>=?,
  ~message: ReactIntl.message,
  ~values: option<{..}>=?,
) => {
  <Link href ?className ?target ?isExternal ?rel> <IntlMessage message ?values /> </Link>
}
