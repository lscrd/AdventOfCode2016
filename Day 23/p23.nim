import std/[strutils, tables]

const RegNames = ["a", "b", "c", "d"]

type

  Registers = Table[char, int]

  Opcode = enum opCpy = "cpy", opInc = "inc", opDec = "dec", opJnz = "jnz", opTgl = "tgl",
                # New instructions added for part 2.
                opNop = "nop", opAdd = "add", opMul = "mul"

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

# Mapping opcode -> toggled opcode (no toggle for extra opcodes).
const ToggleTable: array[OpCode, OpCode] = [opJnz, opDec, opInc, opCpy, opInc, opNop, opAdd, opMul]


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

    of opCpy, opAdd, opMul:
      let src = initOperand(fields[1])
      let dst = initOperand(fields[2])
      inst = Instruction(code: code, op1: src, op2: dst)

    of opInc, opDec:
      let reg = initOperand(fields[1])
      inst = Instruction(code: code, op1: reg)

    of opJnz:
      let condval = initOperand(fields[1])
      let offset = initOperand(fields[2])
      inst = Instruction(code: opJnz, op1: condval, op2: offset)

    of opTgl:
      let offset = initOperand(fields[1])
      inst = Instruction(code: opTgl, op1: offset)

    of opNop:
      inst = Instruction(code: opNop)

    # Add it to memory.
    result.add(inst)


proc run(program: var seq[Instruction]; registers: var Registers) =
  ## Run a program with a given set of registers.

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

    of opTgl:
      let instAddr = pc + inst.op1.value()
      if instAddr in 0..program.high:
        program[instAddr].code = ToggleTable[program[instAddr].code]

    of opNop:
      discard

    of opAdd:
      if inst.op2.opKind == opReg:
        registers[inst.op2.name] += inst.op1.value()

    of opMul:
      if inst.op2.opKind == opReg:
        registers[inst.op2.name] *= inst.op1.value()

    inc pc


### Part 1 ###

var program = loadProgram("p23.data")
var registers = {'a': 7, 'b': 0, 'c': 0, 'd': 0}.toTable()
program.run(registers)
echo "Part 1: ", registers['a']


### Part 2 ###

# For part 2, we could use the same data file or use an optimized version of this file
# which contains new instructions to add and multiply (and also a "nop" instruction).
# With these instructions, execution is accelerated by a factor of at least 1000.

program = loadProgram("p23_optimized.data")    # Load the optimized version of the program.
registers = {'a': 12, 'b': 0, 'c': 0, 'd': 0}.toTable()
program.run(registers)
echo "Part 2: ", registers['a']
