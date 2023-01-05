import std/[sets, tables]

type
  Position = tuple[row, col: int]
  Grid = seq[string]
  Digit = '0'..'9'
  PointPos = Table[Digit, Position]  # Give the position of points of interest.

proc `[]`(grid: Grid; pos: Position): char =
  ## Return the character at given position.
  grid[pos.row][pos.col]

iterator neighbors(grid: Grid; pos: Position): Position =
  ## Yield the positions adjacent to the given position and are not a wall.
  let (r, c) = pos
  for (row, col) in [(r - 1, c), (r + 1, c), (r, c - 1), (r, c + 1)]:
    if grid[row][col] != '#':
      yield (row, col)

# Parse the data file and build the grid.
var grid: Grid
var numPos: PointPos     # Position of points of interest.
var irow = -1
for line in lines("p24.data"):
  inc irow
  grid.add(line)
  # Find the points of interest in this row.
  for icol, c in line:
    if c in '0'..'9':
      numPos[c] = (irow, icol)


### Part 1 ###

iterator reachPoints(grid: Grid; points: PointPos): tuple[steps: int; lastPos: Position] =
  ## Find the paths to reach all the points of interest.
  ## For each path found, yield the number of steps and the last position.

  type
    DigitSet = set[Digit]
    State = tuple[pos: Position; reached: DigitSet]

  const StartingSet = {Digit '0'}
  let startingPos = points['0']
  let pointCount = points.len

  # Mapping of positions already reached to the points reached.
  # Used to avoid useless moves and infinite loop.
  var reached = {startingPos: @[StartingSet]}.toTable

  var currStates: seq[State] = @[(startingPos, StartingSet)]
  var steps = 0
  while currStates.len != 0:
    inc steps
    var newStates: seq[State]
    for state in currStates:
      for pos in grid.neighbors(state.pos):
        if pos notin reached or state.reached notin reached[pos]:
          # Position not yet reached or reached with another set of reached points.
          var pointSet = state.reached
          if grid[pos] != '.':
            pointSet.incl grid[pos]
            if card(pointSet) == pointCount:
              # All points of interest have been reached.
              yield (steps, pos)
              continue
          # Create and add a new state.
          let newState: State = (pos, pointSet)
          newStates.add newState
          reached.mgetOrPut(pos, @[]).add pointSet
    # Switch to new states.
    currStates = move(newStates)

for (steps, lastPos) in grid.reachPoints(numPos):
  echo "Part 1: ", steps
  break


### Part 2 ###

proc shortestPathLen(grid: Grid; startPos, endPos: Position): int =
  ## Return the length of the shortest path to go from "startPos" to "endPos".
  type PositionSet = HashSet[Position]

  var currPos: PositionSet = [startPos].toHashSet()
  while true:
    inc result
    var nextPos: PositionSet = currPos
    for pos in currPos:
      for newPos in grid.neighbors(pos):
        if newPos notin currPos:
          if newPos == endPos: return
          nextpos.incl newPos
    currPos = move(nextPos)

var minSteps = int.high
for (steps1, lastPos) in grid.reachPoints(numPos):
  let steps2 = steps1 + grid.shortestPathLen(lastPos, numPos['0'])
  if steps2 < minSteps:
    minSteps = steps2

echo "Part 2: ", minSteps
