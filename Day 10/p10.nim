import std/[strscans, tables]

type

  # Kind of destination.
  Dest = enum destBot, destOutput

  # Destination as (kind, number).
  Destination = tuple[kind: Dest; num: int]

  # Bot description.
  Bot = ref object
    lowDest: Destination    # Destination for lowest value.
    highDest: Destination   # Destination for highest value.
    value: int              # First value posseded by the bot.

  # Output description as list of values.
  Output = seq[int]

  # Factory description.
  Factory = object
    bots: Table[int, Bot]         # Table of bots.
    outputs: Table[int, Output]   # Table of outputs.
    botNum: int                   # The number of the bot comparing values 17 and 61.

proc addBot(factory: var Factory; num: int; lowDest, highDest: Destination) =
  ## Add a bot defined by its number and its low and high destinations.
  factory.bots[num] = Bot(lowDest: lowDest, highDest: highDest)

proc addOutputValue(factory: var Factory; num, val: int) =
  ## Add a value to an output.
  if val notin factory.outputs.getOrDefault(num):
    factory.outputs.mgetOrPut(num, @[]).add val

proc addBotValue(factory: var Factory; num, val: int) =
  ## Add a value to a bot.

  let bot = factory.bots[num]
  if bot.value == 0:
    # First value. Memorize it.
    bot.value = val

  else:
    # Second value.
    var lowVal = bot.value
    var highVal = val
    if lowVal > highVal: swap lowVal, highVal
    bot.value = 0   # Clear value for next move.
    if lowVal == 17 and highVal == 61:
      factory.botNum = num

    # Move the values to their destinations.
    if bot.lowDest.kind == destBot:
      factory.addBotValue(bot.lowDest.num, lowVal)
    else:
      factory.addOutputValue(bot.lowDest.num, lowVal)
    if bot.highDest.kind == destBot:
      factory.addBotValue(bot.highDest.num, highVal)
    else:
      factory.addOutputValue(bot.highDest.num, highVal)

proc dest(name: string; num: int): Destination =
  ## Return a destination from a string and number.
  if name == "bot": (destBot, num) else: (destOutput, num)


# Parse the input file and build the descriptions.
var factory = Factory(botnum: -1)
var moves: seq[tuple[val, botNum: int]]

for line in lines("p10.data"):
  var val, bot: int
  var lowDest, highDest: string
  var lowNum, highNum: int

  if line.scanf("value $i goes to bot $i", val, bot):
    # Add a value move.
    moves.add (val, bot)
  elif line.scanf("bot $i gives low to $w $i and high to $w $i",
                  bot, lowDest, lowNum, highDest, highNum):
    # Add a bot description.
    factory.addBot(bot, dest(lowDest, lowNum), dest(highDest, highNum))
  else:
    raise newException(ValueError, "wrong input.")

# Execute the moves.
for move in moves:
  factory.addBotValue(move.botNum, move.val)


### Part 1 ###

echo "Part 1: ", factory.botNum


### Part 2 ###

var prod = 1
for num in 0..2:
  for val in factory.outputs[num]:
    prod *= val

echo "Part 2: ", prod
