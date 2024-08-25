import gleam/list
import gleam/string
import gleeunit
import gleeunit/should
import shellout

pub fn main() {
  gleeunit.main()
}

pub fn wc_test() {
  [
    #("-c", "342190 test/wc.txt"),
    #("-l", "7145 test/wc.txt"),
    #("-m", "332147 test/wc.txt"),
    #("-w", "58164 test/wc.txt"),
  ]
  |> list.map(fn(opt) {
    case
      shellout.command(
        run: "gleam",
        with: ["run", "-m", "wc", "--", opt.0, "test/wc.txt"],
        in: ".",
        opt: [],
      )
    {
      Ok(output) ->
        output
        |> string.trim()
        |> string.split("\n")
        |> list.last
        |> should.equal(Ok(opt.1))

      Error(_e) -> should.fail()
    }
  })
}
