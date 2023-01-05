import sets

type

  Element {.pure.} = enum PmG, PmM, PuG, PuM, RuG, RuM, SrG, SrM, TmG, TmM, ElG, ElM, DiG, DiM
  FloorState = set[Element]
  State = tuple[floor: int; elems: array[1..4, FloorState]]
  Generation = HashSet[State]

const
  Generators = [PmG, PuG, RuG, SrG, TmG, ElG, DiG]
  Microships = [PmM, PuM, RuM, SrM, TmM, ElM, DiM]


template isMicrochip(elem: Element): bool = bool(ord(elem) and 1)

func isPossible(state: State): bool =
  ## Check if a state is possible.
  result = true
  for floor in 1..4:
    let fs = state.elems[floor]
    var gencount = 0
    for gen in Generators:
      if gen in fs: inc gencount
    var protected = true
    for chip in Microships:
      if chip in fs and pred(chip) notin fs:
        protected = false
        break
    if not protected and gencount > 0:
      return false

func minSteps(initialState, finalState: State): Natural =
  ## Return the minimum number of steps to go from initial
  ## state to final state.

  var currgen: Generation = [initialState].toHashSet
  var prevgen: Generation

  while true:
    inc result
    var newgen: Generation

    for state in currgen:
      var nextState = state
      let floor = state.floor

      for e1 in state.elems[floor]:
        nextState.elems[floor].excl(e1)

        for nextFloor in [floor - 1, floor + 1]:
          if nextFloor < 1 or nextFloor > 4: continue

          # Move one element.
          nextState.floor = nextFloor
          nextState.elems[nextFloor].incl(e1)
          if nextState notin prevgen:
            if nextState == finalState: return
            if nextState.isPossible():
              newgen.incl(nextState)

          # Move two elements.
          for e2 in state.elems[floor]:
            if e2 <= e1: continue
            if e1.isMicrochip() != e2.isMicrochip() and e2 != succ(e1): continue
            nextState.elems[floor].excl(e2)
            nextState.elems[nextFloor].incl(e2)
            if nextState notin prevgen:
              if nextState == finalState: return
              if nextState.isPossible():
                newgen.incl(nextState)
            nextState.elems[floor].incl(e2)
            nextState.elems[nextFloor].excl(e2)

          nextState.elems[nextFloor].excl(e1)

        nextState.elems[floor].incl(e1)

    prevgen = move(currgen)
    currgen = move(newgen)


### Part 1 ###

const
  InitialState1: State = (1, [{PuG, SrG, TmG, TmM},
                              {PuM, SrM},
                              {PmG, PmM, RuG, RuM},
                              {}])
  FinalState1: State = (4, [{}, {}, {}, {PmG..TmM}])

echo "Part 1: ", minSteps(InitialState1, FinalState1)


### Part 2 ###

const
  InitialState2: State = (1, [{PuG, SrG, TmG, TmM, ElG, ElM, DiG, DiM},
                              {PuM, SrM},
                              {PmG, PmM, RuG, RuM},
                              {}])
  FinalState2: State = (4, [{}, {}, {}, {PmG..DiM}])

echo "Part 2: ", minSteps(InitialState2, FinalState2)
