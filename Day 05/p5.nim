import std/md5

const Hex = "0123456789abcdef"

let doorId = "ffykfhsq"   # Puzzle input.


### Part 1 ###

var n = 0
var password = ""
while password.len != 8:
  let hash = (doorId & $n).toMD5
  if hash[0] == 0 and hash[1] == 0 and hash[2] < 16:
    # Hexadecimal representation starts with five zeroes.
    password.add Hex[hash[2].int8]
  inc n

echo "Part 1: ", password


### Part 2 ###

n = 0
password = "????????"
var remaining = 8
while remaining != 0:
  let hash = (doorId & $n).toMD5
  if hash[0] == 0 and hash[1] == 0 and hash[2] < 16:
    # Hexadecimal representation starts with five zeroes.
    let pos = hash[2].int8
    if pos < 8 and password[pos] == '?':
      # Character at valid position and not yet initialized.
      password[pos] = Hex[hash[3] shr 4]
      dec remaining
  inc n

echo "Part 2: ", password
