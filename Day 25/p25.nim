import std/[strutils, tables]

const RegNames = ["a", "b", "c", "d"]

type

  Registers = Table[char, int]

  Opcode = enum opCpy = "cpy", opInc = "inc", opDec = "dec", opJnz = "jnz", opOut = "out"

  # Type of operands (default opNone means no operand)
  OpKind = enum opNone, opReg, opLit

  # Representation of an operand.
  Operand = object
    case opKind: OpKind
    of opNone: nil
    of opReg: name: char
    of opLit: val: int

  # Representation of an instruction.
  Instruction = object
    code: Opcode
    op1, op2: Operand

func initOperand(s: string): Operand =
  ## Create an operand from a string.
  if s in RegNames:
    Operand(opKind: opReg, name: s[0])
  else:
    Operand(opKind: opLit, val: parseInt(s))


proc loadProgram(filename: string): seq[Instruction] =
  ## Load a progral from a file.

  for line in lines(filename):
    var inst: Instruction
    let fields = line.split(' ')

    # Build the instruction.
    let code = parseEnum[Opcode](fields[0])
    case code

    of opCpy:
      let src = initOperand(fields[1])
      let dst = initOperand(fields[2])
      inst = Instruction(code: code, op1: src, op2: dst)

    of opInc, opDec, opOut:
      let reg = initOperand(fields[1])
      inst = Instruction(code: code, op1: reg)

    of opJnz:
      let condval = initOperand(fields[1])
      let offset = initOperand(fields[2])
      inst = Instruction(code: opJnz, op1: condval, op2: offset)

    # Add it to memory.
    result.add(inst)

iterator run(program: var seq[Instruction]; registers: var Registers): int =
  ## Run a program with a given set of registers.
  ## Yield the successive values produced by "out" instructions.

  template value(operand: Operand): int =
    ## Extract the value of an operand.
    if operand.opKind == opReg: registers[operand.name] else: operand.val

  var pc = 0
  while pc < program.len:
    let inst = program[pc]
    case inst.code

    of opCpy:
      if inst.op2.opKind == opReg:
        registers[inst.op2.name] = inst.op1.value()

    of opInc:
      if inst.op1.opKind == opReg:
        inc registers[inst.op1.name]

    of opDec:
      if inst.op1.opKind == opReg:
        dec registers[inst.op1.name]

    of opJnz:
      let offset = inst.op2.value()
      let condval = inst.op1.value()
      if condval != 0:
        inc pc, offset
        continue

    of opOut:
      yield inst.op1.value()

    inc pc


var program = loadProgram("p25.data")


### Part 1 ###

proc genClockSignal(a: int): bool =
  ## Return true if the program generates a clock signal.
  var registers = {'a': a, 'b': 0, 'c': 0, 'd': 0}.toTable()
  var expected = 0    # Next expected value.
  var count = 1000    # Number of values to check.
  for val in program.run(registers):
    if val != expected: return false
    expected = 1 - expected
    dec count
    if count == 0: return true

var a = 0
while true:
  if genClockSignal(a): break
  inc a
echo "Part 1: ", a
