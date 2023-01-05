import std/strscans

const
  Rows = 6
  Cols = 50

var screen: array[Rows, array[Cols, char]]
for row in screen.mitems:
  for cell in row.mitems:
    cell = ' '

# Parse the input file and execute the instructions.
for line in lines("p8.data"):
  var r, c, n: int
  if line.scanf("rect $ix$i", c, r):
    for i in 0..<r:
      for j in 0..<c:
        screen[i][j] = '#'
  elif line.scanf("rotate row y=$i by $i", r, n):
      var row: array[Cols, char]
      for i in 0..row.high:
        row[(i + n) mod Cols] = screen[r][i]
      screen[r] = row
  elif line.scanf("rotate column x=$i by $i", c, n):
      var col: array[Rows, char]
      for i in 0..col.high:
        col[(i + n) mod Rows] = screen[i][c]
      for i, ch in col: screen[i][c] = ch
  else:
    raise newException(ValueError, "wrong input.")


### Part 1 ###

var count = 0
for row in screen:
  for ch in row:
    if ch == '#':
      inc count

echo "Part 1: ", count


### Part 2 ###

echo "Part 2:"
for row in screen:
  var line = ""
  for i, ch in row:
    if i mod 5 == 0: line.add "  "
    line.add ch
  echo line
