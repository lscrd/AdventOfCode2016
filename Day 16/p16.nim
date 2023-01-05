const
  Input = "10001110011110000"
  Disklen1 = 272        # For part 1.
  Disklen2 = 35651584   # For part 2.

template isOdd(n: int): bool = (n and 1) != 0

proc diskData(diskLen: Positive): string =
  # Build the data to use to fill the disk.
  result = Input
  while result.len < diskLen:
    result.add('0')
    for i in countdown(result.high - 1, 0):
      result.add(if result[i] == '0': '1' else: '0')
  result.setLen(diskLen)

proc checksum(data: string): string =
  ## Return the checksum for the given data.
  var data = data
  while true:
    result = ""
    for i in countup(0, data.high, 2):
      result.add(if data[i] == data[i + 1]: '1' else: '0')
    if result.len.isOdd: break
    data = result   # For next round.


### Part 1 ###
echo "Part 1: ", diskData(Disklen1).checksum()

### Part 2 ###
echo "Part 2: ", diskData(Disklen2).checksum()
