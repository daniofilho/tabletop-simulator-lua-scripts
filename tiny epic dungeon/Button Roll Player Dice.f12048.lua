function rollPlayerDice()
  local dice1 = getObjectFromGUID("a74555")
  local dice2 = getObjectFromGUID("3f5d43")
  local dice3 = getObjectFromGUID("3a6965")
  dice1.randomize()
  dice2.randomize()
  dice3.randomize()
end