import std/strscans

type Disc = tuple[positions, initpos: int]


proc getDiscs(filename: string): seq[Disc] =
  # Initialize list of discs from file.
  for line in lines(filename):
    var num, positions, initpos: int
    if not line.scanf("Disc #$i has $i positions; at time=0, it is at position $i.",
                      num, positions, initpos):
      raise newException(ValueError, "wrong input.")
    assert num == result.len + 1, "disc is out of order."
    result.add (positions, initpos)


func getStartingTime(discs: seq[Disc]): Natural =
  # Find the starting time to use to get the capsule.
  while true:
    var t = result
    for n, disc in discs:
      inc t
      if (t + disc.initpos) mod disc.positions != 0:
        break   # One disc is not at position 0.
      if n == discs.high:
        return  # All discs are at position 0.
    inc result


var discs = getDiscs("p15.data")

### Part 1 ###
echo "Part 1: ", getStartingTime(discs)

### Part 2 ###
discs.add (11, 0)
echo "Part 2: ", getStartingTime(discs)
