# Find the triples and the quintuples and use them to find the keys.
# For part 1, this algorithm is faster than the other one as it searches triples
# and quintuples only once, but it requires to set a limit for the number of hashes
# to precompute.
# For part 2, where hash computation is costly, the other algorithm is better as there is
# no need to precompute the hashes. Of course, if we use a limit close to the result, with
# this algorithm, it is possible to get similar or even slightly better execution times.

import std/[algorithm, md5, sequtils, tables]

const N = 25_000
const Salt = "ahsbgdzn"

type

  Triples = OrderedTable[int, char]     # Maps index to character of triple.
  Quintuples = Table[char, seq[int]]    # Maps character to list of indexes.


proc prepareTables(triples: var Triples; quintuples: var Quintuples; stretch: Natural) =
  ## Build the tables of triples and quintuples.

  for idx in 0..N:
    block scan:
      var hash = getMD5(Salt & $idx)
      for i in 1..stretch: hash = getMD5(hash)

      # Search quintuples.
      for i in 0..hash.high - 4:
        let ch = hash[i]
        if hash[i + 1] == ch and hash[i + 2] == ch:
          # Found at least a triple.
          triples[idx] = ch
          if hash[i + 3] == ch and hash[i + 4] == ch:
            # Found a quintuple.
            quintuples.mgetOrPut(ch, @[]).add idx
          break scan

      # Search triples in the remaining last three characters.
      for i in hash.high - 3..hash.high - 2:
        let ch = hash[i]
        if hash[i + 1] == ch and hash[i + 2] == ch:
          triples[idx] = ch


proc indexOfKey(n: Positive; stretch: Natural): int =
  ## Return the index of key number "n" using MD5 with "stretch" additional rounds.

  var triples: Triples
  var quintuples: Quintuples

  prepareTables(triples, quintuples, stretch)

  var count = 0
  # Start from triples.
  for idx1 in sorted(toSeq(triples.keys)):
    let ch = triples[idx1]
    if ch in quintuples:
      # There exists quintuples with this character.
      for idx2 in quintuples[ch]:
        if idx2 <= idx1: continue     # Quintuple index precedes triple index.
        if idx2 > idx1 + 1000: break  # Quintuple index it too far from triple index.
        inc count
        if count == n: return idx1


### Part 1 ###
echo "Part 1: ", indexOfKey(64, 0)


### Part 2 ###
echo "Part 2: ", indexOfKey(64, 2016)
