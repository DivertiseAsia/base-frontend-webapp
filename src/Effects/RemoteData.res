type t<'a, 'p, 'e> =
  | NotAsked
  | Loading('p)
  | Failure('e)
  | Success('a)

let isLoading = (data: t<'a, 'p, 'e>): bool => {
  switch data {
  | Loading(_) => true
  | _ => false
  }
}
