import std/tables

# Fill eight count tables.
var freq: array[8, CountTable[char]]
for line in lines("p6.data"):
  for i, c in line:
    freq[i].inc(c)


### Part 1 ###

var result1 = ""
for f in freq:
  result1.add f.largest[0]

echo "Part 1: ", result1


### Part 2 ###

var result2 = ""
for f in freq:
  result2.add f.smallest[0]

echo "Part 2: ", result2
