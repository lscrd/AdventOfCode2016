import std/strscans

iterator rows(filename: string): tuple[a, b, c: int] =
  ## Yield the successive groups of three values.
  for line in lines(filename):
    var a, b, c: int
    if not scanf(line, "$s$i $s$i $s$i", a, b, c):
      raise newException(ValueError, "wrong input.")
    yield (a, b, c)


### Part 1 ###

var count = 0
for (a, b, c) in rows("p3.data"):
  if a + b > c and b + c > a and c + a > b:
    inc count

echo "Part 1: ", count


### Part 2 ###

var a, b, c: array[3, int]
var i = 0
count = 0

for row in rows("p3.data"):
  (a[i], b[i], c[i]) = row
  inc i
  if i == 3:
    # We have got three values for each column.
    for t in [a, b, c]:
      if t[0] + t[1] > t[2] and t[1] + t[2] > t[0] and t[2] + t[0] > t[1]:
        inc count
    i = 0

echo "Part 2: ", count
