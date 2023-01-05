import std/[bitops, sets]

const Favnum = 1352

type Coords = tuple[x, y: int]
type CoordSet = HashSet[Coords]

proc isOpenspace(pos: Coords): bool =
  ## Check if there is an open space at given position.
  let (x, y) = pos
  var val = x * x + 3 * x + 2 * x * y + y + y * y + Favnum
  result = (countSetBits(val) and 1) == 0

const
  Start: Coords = (1, 1)
  Target: Coords = (31, 39)


iterator nextPositions(current: CoordSet): Coords =
  ## Starting from positions in "current", yield the next positions.
  for pos in current:
    for newpos in [Coords((pos.x - 1, pos.y)), Coords((pos.x, pos.y - 1)),
                   Coords((pos.x + 1, pos.y)), Coords((pos.x, pos.y + 1))]:
      if newpos.x >= 0 and newpos.y >= 0 and newpos.isOpenspace:
        yield newpos


func minSteps(start, target: Coords): Natural =
  ## Return the minimal number of steps to go from "start" to "target".

  var previous: CoordSet
  var current: CoordSet = @[start].toHashSet

  while true:
    inc result
    var next: CoordSet
    for newpos in current.nextPositions():
      if newpos == target: return
      if newpos notin previous: next.incl newpos
    previous = current
    current = next


func locCount(start: Coords; nsteps: Positive): Natural =
  ## Return the number of locations reachable from "start" in at most "nsteps" steps.

  var locations: CoordSet = [(1, 1)].toHashSet()
  var current: CoordSet = @[start].toHashSet

  for step in 1..nsteps:
    var next: CoordSet
    for newpos in current.nextPositions():
      if newpos notin locations:
        next.incl newpos
        locations.incl newpos
    current = next

  result = card(locations)


### Part 1 ###
echo "Part 1: ", minSteps(Start, Target)


### Part 2 ###
echo "Part 2: ", locCount(Start, 50)
