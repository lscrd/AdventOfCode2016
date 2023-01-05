import std/tables

type Tables = tuple[up, down, right, left: Table[char, char]]


proc buildCode(filename: string; tables: Tables): string =
  ## Build the code from the file instructions.
  var digit = '5'
  for line in lines(filename):
    for dir in line:
      digit = case dir
              of 'U': tables.up[digit]
              of 'D': tables.down[digit]
              of 'R': tables.right[digit]
              of 'L': tables.left[digit]
              else: raise newException(ValueError, "wrong input.")
    result.add digit


### Part 1 ###

const

  Up1 = {'1': '1', '2': '2', '3': '3',
         '4': '1', '5': '2', '6': '3',
         '7': '4', '8': '5', '9': '6'}.toTable()

  Down1 = {'1': '4', '2': '5', '3': '6',
           '4': '7', '5': '8', '6': '9',
           '7': '7', '8': '8', '9': '9'}.toTable()

  Right1 = {'1': '2', '2': '3', '3': '3',
            '4': '5', '5': '6', '6': '6',
            '7': '8', '8': '9', '9': '9'}.toTable()

  Left1 = {'1': '1', '2': '1', '3': '2',
           '4': '4', '5': '4', '6': '5',
           '7': '7', '8': '7', '9': '8'}.toTable()

echo "Part 1: ", buildCode("p2.data", (Up1, Down1, Right1, Left1))


### Part 2 ###

const

  Up2 = {'1': '1',
         '2': '2', '3': '1', '4': '4',
         '5': '5', '6': '2', '7': '3', '8': '4', '9': '9',
         'A': '6', 'B': '7', 'C': '8',
         'D': 'B'}.toTable()

  Down2 = {'1': '3',
           '2': '6', '3': '7', '4': '8',
           '5': '5', '6': 'A', '7': 'B', '8': 'C', '9': '9',
           'A': 'A', 'B': 'D', 'C': 'C',
           'D': 'D'}.toTable()

  Right2 = {'1': '1',
            '2': '3', '3': '4', '4': '4',
            '5': '6', '6': '7', '7': '8', '8': '9', '9': '9',
            'A': 'B', 'B': 'C', 'C': 'C',
            'D': 'D'}.toTable()

  Left2 = {'1': '1',
           '2': '2', '3': '2', '4': '3',
           '5': '5', '6': '5', '7': '6', '8': '7', '9': '8',
           'A': 'A', 'B': 'A', 'C': 'B',
           'D': 'D'}.toTable()

echo "Part 2: ", buildCode("p2.data", (Up2, Down2, Right2, Left2))
