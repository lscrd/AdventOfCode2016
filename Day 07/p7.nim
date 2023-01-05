### Part 1 ###

proc countTls(filename: string): int =
  ## Parse the input file and return the number of IPs supporting TLS.

  for line in lines(filename):
    var supportTls, inBrackets = false
    for i in 0..(line.high - 3):
      let c1 = line[i]
      let c2 = line[i + 1]
      if c1 == '[':
        inBrackets = true
        continue
      if c1 == ']':
        inBrackets = false
        continue
      if c1 == c2:
        continue
      if line[i + 2] == c2 and line[i + 3] == c1:
        if inBrackets:
          supportTls = false
          break
        else:
          supportTls = true

    inc result, ord(supportTls)

echo "Part 1: ", countTls("p7.data")


### Part 2 ###

type Couple = tuple[a, b: char]

proc countSsl(filename: string): int =

  for line in filename.lines:

    # Find "aba" and "bab" sequences.
    var aba, bab: seq[Couple]
    var inBrackets = false
    for i in 0..(line.high - 2):
      let c1 = line[i]
      let c2 = line[i + 1]
      if c1 == '[':
        inBrackets = true
        continue
      if c1 == ']':
        inBrackets = false
        continue
      if c1 == c2:
        continue
      if line[i + 2] == c1:
        if inBrackets:
          bab.add((c2, c1))
        else:
          aba.add((c1, c2))

    # Search matching "aba" and "bab".
    for ab in aba:
      if ab in bab:
        inc result
        break

echo "Part 2: ", countSsl("p7.data")
