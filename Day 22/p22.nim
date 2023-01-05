import std/[strscans, strutils, tables]

type
  Coords = tuple[x, y: int]
  Node = ref object
    coords: Coords
    used, avail: int
  Grid = seq[seq[Node]]

proc loadGrid(filename: string): Grid =
  ## Load the grid from the file.
  for line in filename.lines:
    if not line.startsWith("/dev"): continue
    var x, y, size, used, avail, percent: int
    discard line.scanf("/dev/grid/node-x$i-y$i $s$iT $s$iT $s$iT $s$i%",
                       x, y, size, used, avail, percent)
    if result.len <= y: result.setLen(y + 1)
    if result[y].len <= x: result[y].setLen(x + 1)
    result[y][x] = Node(coords: (x, y), used: used, avail: avail)

iterator nodes(grid: Grid): Node =
  ## Yield the nodes.
  for row in grid.items:
    for node in row:
      yield node

# Load the grid from data file.
var grid = loadGrid("p22.data")


### Part 1 ###

var viables = 0
for node1 in grid.nodes:
  if node1.used != 0:
    for node2 in grid.nodes:
      if node1.coords != node2.coords:
        if node1.used <= node2.avail:
          inc viables

echo "Part 1: ", viables


### Part 2 ###

# Cache containing the length of shortest paths for couples (free node, destination node).
var cache: Table[(Coords, Coords), int]

iterator neighbors(grid: Grid, node: Node): Node =
  ## Yield the neighbors of a node.
  let (x, y) = node.coords
  if y - 1 >= 0:
    yield grid[y - 1][x]    # Up.
  if x + 1 <= grid[y].high:
    yield grid[y][x + 1]    # Right.
  if y + 1 <= grid.high:
    yield grid[y + 1][x]    # Down.
  if x - 1 >= 0:
    yield grid[y][x - 1]    # Left.

proc moveData(fromNode, toNode: Node) =
  ## Move data from one node to another.
  inc toNode.used, fromNode.used
  dec toNode.avail, fromNode.used
  inc fromNode.avail, fromNode.used
  fromNode.used = 0

proc shortestPathLength(grid: Grid; freeNode, destNode: Node;
                        path: seq[Coords] = @[]): Natural =
  ## Return the length of the shortest path to move data from "destNode" to "freeNode".

  # Destination node reached?
  if freeNode.coords == destNode.coords: return 0

  # In cache?
  let key = (freeNode.coords, destNode.coords)
  if key in cache: return cache[key]

  # Try to move to each neighbor.
  result = Natural.high
  let path = path & freeNode.coords
  for node in grid.neighbors(freeNode):
    if node.coords in path or node.used > freeNode.avail:
      continue      # Impossible to move data
    moveData(node, freeNode)
    # Find shortest length from "node" to "destNode".
    let length = grid.shortestPathLength(node, destNode, path)
    if length < result: result = length
    moveData(freeNode, node)  # Restore attributes of nodes.

  if result != Natural.high:
    # Found a path. Add current move.
    inc result

  cache[key] = result


# Find the free node.
var freeNode: Node
for node in grid.nodes:
  if node.used == 0:
    freeNode = node

# Move the target data into the node at position (0, 0).
var target = grid[0][^1]
var steps = 0
while target != grid[0][0]:
  # Move free node just before the target node.
  let destNode = grid[0][target.coords.x - 1]
  inc steps, grid.shortestPathLength(freeNode, destNode)
  freeNode = destNode
  # Move target data to free node.
  moveData(target, freeNode)
  swap target, freeNode
  inc steps

echo "Part 2: ", steps
