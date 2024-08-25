import gleam/int
import gleam/io
import gleam/list
import gleam/string
import shellout
import simplifile

pub fn main() {
  case shellout.arguments() {
    [option, filename] ->
      case filename |> simplifile.read {
        Ok(contents) ->
          contents
          |> case option {
            "-l" -> count_lines
            "-m" -> string.length
            "-c" -> string.byte_size
            "-w" -> count_words
            _ -> string.byte_size
          }
          |> int.to_string
          <> " "
          <> filename
          <> "\n"
        Error(e) -> e |> simplifile.describe_error <> " " <> filename <> "\n"
      }
    _ -> "Usage: wc [option] [filename]\n"
  }
  |> io.print
}

fn count_lines(contents: String) -> Int {
  contents
  |> string.split("\n")
  |> list.length
  |> int.subtract(1)
}

fn count_words(contents: String) -> Int {
  contents
  |> string.split("\n")
  |> list.map(count_words_in_line)
  |> list.fold(0, fn(x, y) { x + y })
}

fn count_words_in_line(line: String) -> Int {
  line
  |> string.replace("\t", " ")
  |> string.split(" ")
  |> list.filter(fn(x) { x != "" && x != "\r" })
  |> io.debug
  |> list.length
}
