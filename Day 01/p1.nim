import std/[sets, strutils, tables]

# North = (0, 1), East = (1, 0), South = (0, -1), West = (-1, 0).

const Right = {(0,  1): ( 1, 0), ( 1, 0): (0, -1),
               (0, -1): (-1, 0), (-1, 0): (0,  1)}.toTable()

const Left = {(0,  1): (-1, 0), (-1, 0): (0, -1),
              (0, -1): ( 1, 0), ( 1, 0): (0,  1)}.toTable()

var x = 0
var y = 0
var dx = 0    # X direction.
var dy = 1    # Y direction.

let data = readFile("p1.data")


### Part 1 ###

for move in data.split(", "):
  let dir = move[0]
  let dist = parseInt(move[1..^1])
  (dx, dy) = if dir == 'R': Right[(dx, dy)] else: Left[(dx, dy)]
  x += dx * dist
  y += dy * dist

echo "Part 1: ", abs(x) + abs(y)


### Part 2 ###

var locations = [(0, 0)].toHashSet()

x = 0
y = 0
dx = 0
dy = 1

block Move:
  for move in data.split(", "):
    let dir = move[0]
    let dist = parseInt(move[1..^1])
    (dx, dy) = if dir == 'R': Right[(dx, dy)] else: Left[(dx, dy)]
    # Move step by step to check if each location has yet been encountered.
    for i in 1..dist:
      x += dx
      y += dy
      if (x, y) in locations:
        break Move
      locations.incl((x, y))

echo "Part 2: ", abs(x) + abs(y)
