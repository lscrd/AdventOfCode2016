func getvalue(text: string; pos: var int): int =
  ## Extract a value from a string, updating the current position.
  while true:
    result = 10 * result + ord(text[pos]) - ord('0')
    inc pos
    if text[pos] notin {'0'..'9'}:
      break


func decompressedLength1(text: string): int =
  ## Return the length of the decompressed string
  ## using version 1 of decompression algorithm.

  var pos = 0
  while pos < text.len:
    let ch = text[pos]
    inc pos
    if ch == '(':
      # Entering a marker.
      let nchars = text.getvalue(pos)
      inc pos  # Skip 'x'.
      let repeat = text.getvalue(pos)
      inc pos  # Skip ')'.
      inc result, nchars * repeat
      inc pos, nchars
    else:
      # Normal char.
      inc result


func decompressedLength2(text: string): int =
  ## Return the length of the decompressed string
  ## using version 2 of decompression algorithm.

  var pos = 0
  while pos < text.len:
    let ch = text[pos]
    inc pos
    if ch == '(':
      # Entering a marker.
      let nchars = text.getvalue(pos)
      inc pos   # Skip 'x'.
      let repeat = text.getvalue(pos)
      inc pos   # Skip ')'.
      inc result, repeat * text[pos..(pos + nchars - 1)].decompressedLength2()
      inc pos, nchars
    else:
      # Normal char.
      inc result


let compressed = readFile("p9.data")

### Part 1 ###
echo "Part 1: ", compressed.decompressedLength1()

### Part 2 ###
echo "Part 2: ", compressed.decompressedLength2()
