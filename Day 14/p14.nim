# Direct implementation which uses a cache to avoid
# recomputing the hashes several times.

import std/[md5, tables]

const Salt = "ahsbgdzn"

var cache: Table[int, string]     # To avoid recomputing the hashes.


proc md5Value(n: int; stretch: Natural): string =
  ## Compute a MD5 value using a cache and applying stretching if requested.
  if n in cache:
    result = cache[n]
  else:
    result = getMD5(Salt & $n)
    for i in 1..stretch:
      result = getMD5(result)  # Additional rounds for stretching.
    cache[n] = result


proc indexOfKey(n: Positive; stretch: Natural): int =
  ## Return the index of key number "n" using MD5 with "stretch" additional rounds.

  cache.clear()
  var count = 0
  result = -1

  while count != n:
    inc result
    let hash = md5Value(result, stretch)
    var candidate = false
    var ch: char
    # Check if there are three successive identical characters.
    for i in 0..hash.high - 2:
      ch = hash[i]
      if hash[i + 1] == ch and hash[i + 2] == ch:
        candidate = true
        break

    if candidate:
      # Check if there are five successive identical characters.
      block find5:
        for idx in (result + 1)..(result + 1000):
          let hash = md5Value(idx, stretch)
          for i in 0..(hash.high - 4):
            if hash[i] == ch and hash[i + 1] == ch and
              hash[i + 2] == ch and hash[i + 3] == ch and hash[i + 4] == ch:
                inc count
                break find5


### Part 1 ###
echo "Part 1: ", indexOfKey(64, 0)


### Part 2 ###
echo "Part 2: ", indexOfKey(64, 2016)
