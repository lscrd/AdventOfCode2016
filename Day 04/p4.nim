import std/[algorithm, strutils, sugar]

type
  Lowercase = 'a'..'z'
  Room = tuple[name: string; sectorId: int]


### Part 1 ###

var result1 = 0
var rooms: seq[Room]
for line in lines("p4.data"):

  # Parse line and count lowercase letters.
  var count: array[Lowercase, int]
  let parts = line.split('[')
  let checksum = parts[1][0..^2]
  let fields = parts[0].rsplit('-', 1)
  let sectorId = parseInt(fields[1])
  for field in fields[0].split('-'):
    for c in field: inc count[c]

  # Build a list to sort the letters, then sort.
  var scount = collect(for ch, val in count: (count: val, value: -ord(ch), letter: ch))
  scount.sort(Descending)

  # Verify the checksum.
  var ck = newString(5)
  for i in 0..4: ck[i] = scount[i].letter
  if ck == checksum:
    result1 += sectorId
    rooms.add (fields[0], sectorId)    # Store real rooms for second part.

echo "Part 1: ", result1


### Part 2 ###

proc decrypt(name: string; sectorId: int): string =
  ## Decrypt a name using the given room sector ID.
  let shift = sectorId mod 26
  for c in name:
    result.add if c == '-': ' '
               else: chr(ord('a') + (ord(c) - ord('a') + shift) mod 26)

var result2: int
for (name, sectorId) in rooms:
  let clearName = name.decrypt(sectorId)
  if clearName.startsWith("north"):
    result2 = sectorId
    break

echo "Part 2: ", result2
