const N = 3014387

func findElfNumber1(): int =
  ## The result is computed backwards. We start from the winner at
  ## position 0 on last round and compute its position on previous rounds.
  var pos = 0
  for n in 3..N:
    pos = (pos + 2) mod n
  result = pos + 1

func findElfNumber2(): int =
  ## Same logic here, but the algorithm to compute the previous positions
  ## is more complicated.
  var pos = 0
  for n in 3..N:
    pos = (pos + 1) mod n
    if pos >= n div 2:
      pos = (pos + 1) mod n
  result = pos + 1

### Part 1 ###
echo "Part 1: ", findElfNumber1()

### Part 2 ###
echo "Part 2: ", findElfNumber2()
