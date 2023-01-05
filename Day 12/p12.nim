import std/[strutils, tables]

const RegNames = ["a", "b", "c", "d"]

type

  Registers = Table[char, int]

  Opcode = enum opCpy = "cpy", opInc = "inc", opDec = "dec", opJnz = "jnz"

  Operand = object
    case register: bool
    of false: val: int
    of true: name: char

  Instruction = object
    case code: Opcode
    of opCpy:
      dstReg: char
      src: Operand
    of opInc, opDec:
      reg: char
    of opJnz:
      condval: Operand
      offset: Operand


func initOperand(s: string): Operand =
  ## Create an operand.
  if s in RegNames:
    Operand(register: true, name: s[0])
  else:
    Operand(register: false, val: parseInt(s))


proc loadProgram(filename: string): seq[Instruction] =
  ## Parse the data file and return a sequence of instructions.

  for line in lines(filename):
    var inst: Instruction
    let fields = line.split(' ')

    # Build the instruction.
    let code = parseEnum[Opcode](fields[0])
    case code
    of opCpy:
      let dstReg = fields[2][0]
      let src = initOperand(fields[1])
      inst = Instruction(code: opCpy, dstReg: dstReg, src: src)
    of opInc, opDec:
      inst = Instruction(code: code, reg: fields[1][0])
    of opJnz:
      let condval = initOperand(fields[1])
      let offset = initOperand(fields[2])
      inst = Instruction(code: opJnz, condval: condval, offset: offset)

    result.add(inst)


proc run(program: seq[Instruction]; registers: var Registers) =
  ## Run the given program with the given registers.

  template value(operand: Operand): int =
    ## Return the value of an operand.
    if operand.register: registers[operand.name] else: operand.val

  var pc = 0
  while pc < program.len:
    let inst = program[pc]
    case inst.code
    of opCpy:
      registers[inst.dstReg] = inst.src.value()
    of opInc:
      inc registers[inst.reg]
    of opDec:
      dec registers[inst.reg]
    of opJnz:
      let offset = inst.offset.value()
      let condval = inst.condval.value()
      if condval != 0:
        inc pc, offset
        continue
    inc pc


let program = loadProgram("p12.data")


### Part 1 ###
var registers = {'a': 0, 'b': 0, 'c': 0, 'd': 0}.toTable()
program.run(registers)
echo "Part 1: ", registers['a']


### Part 2 ###
registers = {'a': 0, 'b': 0, 'c': 1, 'd': 0}.toTable()
program.run(registers)
echo "Part 2: ", registers['a']
