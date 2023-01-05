import std/strscans

const MaxAddress = 4_294_967_295  # 2^32 - 1.

type Range = tuple[min, max: int]


proc intersect(r1, r2: Range): bool =
  ## Return true if ranges intersect.
  r1.max >= r2.min and r2.max >= r1.min

proc mergeRanges(ranges: var seq[Range]) =
  ## Merge the consecutive ranges into one single range.
  for i in countdown(ranges.high - 1, 0):
    if ranges[i].max + 1 >= ranges[i + 1].min:
      if ranges[i].max < ranges[i + 1].max:
        ranges[i].max = ranges[i + 1].max
      ranges.delete(i + 1)

proc getRanges(filename: string): seq[Range] =
  # Build the list fo ranges from a file.

  result = @[(int.high, int.high)]  # Initialize with a sentinel.

  for line in lines(filename):
    var val1, val2: int
    if not line.scanf("$i-$i", val1, val2):
      raise newException(ValueError, "wrong input.")

    let newrange: Range = (val1, val2)
    var pos = 0
    for r in result.mitems:
      if r.intersect(newrange):
        # Update existing range.
        if val1 < r.min: r.min = val1
        if val2 > r.max: r.max = val2
        break
      elif val2 < r.min:
        # Insert a new range.
        result.insert(newrange, pos)
        break
      inc pos
    result.mergeRanges()

  discard result.pop()  # Remove the sentinel.


let ranges = getRanges("p20.data")

### Part 1 ###
echo "Part 1: ", ranges[0].max + 1

### Part 2 ###
var allowed = MaxAddress + 1  # From 0 to MaxAddress.
for r in ranges:
  dec allowed, r.max - r.min + 1
echo "Part 2: ", allowed
