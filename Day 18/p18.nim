import std/strutils

func safeTileCount(firstRow: string; nrows: Positive): Natural =
  var row = '.' & firstRow & '.'  # Add two "dummy" safe tiles.
  result = firstRow.count('.')
  for _ in 1..<nrows:
    var nextrow = newstring(row.len)
    nextrow[0] = '.'
    nextrow[^1] = '.'
    for i in 1..<row.high:
      let prev = row[(i - 1)..(i + 1)]
      nextrow[i] = if prev in ["^..", "..^", "^^.", ".^^"]: '^' else: '.'
    row = nextrow
    inc result, row.count('.') - 2

let row1 = readFile("p18.data")

### Part 1 ###
echo "Part 1: ", safeTileCount(row1, 40)

### Part 2 ###
echo "Part 2: ", safeTileCount(row1, 400_000)
