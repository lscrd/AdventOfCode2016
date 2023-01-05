import std/[algorithm, strutils]

type

  Opcode {.pure.} = enum
    SwapPos
    SwapLetter
    RotateLeft
    RotateRight
    RotateBased
    ReversePos
    MovePos

  Operation = object
    case opcode: Opcode
    of SwapPos:
      swapPos1: int
      swapPos2: int
    of SwapLetter:
      swapLetter1: char
      swapLetter2: char
    of RotateLeft, RotateRight:
      rot: int
    of RotateBased:
      rotLetter: char
    of ReversePos:
      revPos1: int
      revPos2: int
    of MovePos:
      movePos1: int
      movePos2: int


proc loadOperations(filename: string): seq[Operation] =
  ## Read operations from file.

  for line in lines(filename):

    let f = line.split()
    case f[0] & " " & f[1]
    of "swap position":
      result.add Operation(opcode: SwapPos, swapPos1: parseInt(f[2]), swapPos2: parseInt(f[5]))
    of "swap letter":
      result.add Operation(opcode: SwapLetter, swapLetter1: f[2][0], swapLetter2: f[5][0])
    of "rotate left":
      result.add Operation(opcode: RotateLeft, rot: parseInt(f[2]))
    of "rotate right":
      result.add Operation(opcode: RotateRight, rot: parseInt(f[2]))
    of "rotate based":
      result.add Operation(opcode: RotateBased, rotLetter: f[6][0])
    of "reverse positions":
      result.add Operation(opcode: ReversePos, revPos1: parseInt(f[2]), revPos2: parseInt(f[4]))
    of "move position":
      result.add Operation(opcode: MovePos, movePos1: parseInt(f[2]), movePos2: parseInt(f[5]))
    else:
      raise newException(ValueError, "wrong input.")


proc rotation(pos: Natural): Natural =
  ## Compute the rotation for "rotate based on position of letter".
  pos + 1 + ord(pos >= 4)


proc reversedRotations(n: Positive): seq[Natural] =
  ## Compute the right rotations to use to reverse "rotate based on position of letter"
  ## These rotations depends on the length of the text.

  result.setlen(n)
  for pos1 in 0..<n:
    let rot = rotation(pos1)
    let pos2 = (pos1 + rot) mod n
    result[pos2] = (pos1 - pos2 + n) mod n


proc apply(text: string; operations: seq[Operation]; reverse = false): string =
  ## Apply a sequence of operations on a text, either in normal order or in reverse order.

  # Build the reverse rotations.
  let revRotations = reversedRotations(text.len)

  result = text
  let operations = if reverse: reversed(operations) else: operations
  for op in operations:
    case op.opcode

    of SwapPos:
      swap result[op.swapPos1], result[op.swapPos2]

    of SwapLetter:
      let pos1 = result.find(op.swapLetter1)
      let pos2 = result.find(op.swapLetter2)
      swap result[pos1], result[pos2]

    of RotateLeft, RotateRight:
      var n = op.rot mod result.len
      if n == 0: continue
      if op.opcode == RotateRight xor reverse: # Rotate right or reverse rotate left.
        n = (result.len - n) mod result.len    # -> transform in rotate left.
      result = result[n..^1] & result[0..<n]

    of RotateBased:
      let pos = result.find(op.rotLetter)
      let n = if reverse: revRotations[pos] else: rotation(pos) mod result.len
      if n > 0: result = result[^n..^1] & result[0..^(n + 1)]

    of ReversePos:
      for i in 0..(op.revPos2 - op.revPos1 - 1) div 2:
        swap result[op.revPos1 + i], result[op.revPos2 - i]

    of MovePos:
      var (pos1, pos2) = (op.movePos1, op.movePos2)
      if reverse: swap pos1, pos2
      let c = result[pos1]
      result.delete(pos1..pos1)
      result = result[0..<pos2] & c & result[pos2..^1]


let operations = loadOperations("p21.data")

### Part 1 ###
echo "Part 1: ", "abcdefgh".apply(operations)

### Part 2 ###
echo "Part 2: ", "fbgdceah".apply(operations, reverse = true)
