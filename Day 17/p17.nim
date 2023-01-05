import std/[md5, tables]

const Passcode = "mmsxrhfx"

type
  Position = tuple[path: string, x, y: int]
  Positions = seq[Position]
  Direction = char

const Deltas = {'U': (-1, 0), 'D': (1, 0), 'L': (0, -1), 'R': (0, 1)}.toTable


iterator nextdirs(pos: Position): Direction =
  ## Yield the directions possible from current position.
  let hash = getMD5(Passcode & pos.path)
  if hash[0] > 'a' and pos.x > 0: yield 'U'
  if hash[1] > 'a' and pos.x < 3: yield 'D'
  if hash[2] > 'a' and pos.y > 0: yield 'L'
  if hash[3] > 'a' and pos.y < 3: yield 'R'


proc shortestPath(): string =
  ## Return the shortest path to reach the vault.
  var positions: Positions = @[(path: "", x: 0, y: 0)]
  while true:
    var nextPositions: Positions
    for pos in positions:
      for dir in pos.nextdirs():
        let nextpos = (path: pos.path & dir,
                       x: pos.x + Deltas[dir][0],
                       y: pos.y + Deltas[dir][1])
        if nextpos.x == 3 and nextpos.y == 3:
          return nextpos.path
        nextPositions.add nextpos
    positions = nextPositions


proc longestPathLength(): Natural =
  ## Return the length of the longest path to reach the vault.
  var positions: Positions = @[(path: "", x: 0, y: 0)]
  while positions.len > 0:
    var nextPositions: Positions
    for pos in positions:
      for dir in nextdirs(pos):
        let nextpos = (path: pos.path & dir,
                       x: pos.x + Deltas[dir][0],
                       y: pos.y + Deltas[dir][1])
        if nextpos.x == 3 and nextpos.y == 3:
          if nextpos.path.len > result:
            result = nextpos.path.len
        else:
          nextPositions.add nextpos
    positions = nextPositions


### Part 1 ###
echo "Part 1: ", shortestPath()

### Part 2 ###
echo "Part 2: ", longestPathLength()
