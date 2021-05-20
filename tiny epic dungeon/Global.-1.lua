-- bUG: O tile Lair sempre fica no final, não está sendo embaralhado

function shuffle(tbl)
  shuffled = {}
  for i, v in ipairs(tbl) do
    local pos = math.random(1, #shuffled+1)
    table.insert(shuffled, pos, v)
  end
  return shuffled
end

function setupGame(players)
  
  local spellDeck = getObjectFromGUID("3bb118")
  local lootDeck = getObjectFromGUID("2d8c58")
  
  local roomsDeck = getObjectFromGUID("f3aee9")
  local roomsCards = roomsDeck.getObjects()

  local encountersDeck = getObjectFromGUID("8687e0")
  local encountersCards = encountersDeck.getObjects()

  local lair = getObjectFromGUID("293697")

  local entranceCard = getObjectFromGUID("a91e3f")
  local entrancePos = entranceCard.getPosition()

  local finalDeckZone = getObjectFromGUID("924721"); 
  local finalDeckZonePos = finalDeckZone.getPosition()
  
  local tempDeckZone = getObjectFromGUID("35b4de"); 
  local tempDeckZonePos = tempDeckZone.getPosition()

  -- # embaralha os decks iniciais
  spellDeck.randomize()
  lootDeck.randomize()
  roomsDeck.randomize()
  encountersDeck.randomize()

  -- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

  -- # Monta o Deck de Tiles com base no número de players
  local finalDeck = {}
  local deckA = {}
  local deckB = {}
  local deckC = {}

  -- ## Passo A
  -- Pega cartas de sala com base no número de jogadores
  -- 2 heroes => 9 cards 
  -- 3 heroes => 7 cards 
  -- 4 heroes => 5 cards
  
  local limit = 5 -- 4
  if players == 2 then limit = 9 end
  if players == 3 then limit = 7 end

  for i = 1, limit do
    local card = roomsDeck.takeObject({guid = roomsCards[i]})
    table.insert(deckA, card)
  end
  
  -- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
  
  -- ## Passo B
  
  -- adiciona 1 carta de Encontro para cada jogador
  for i = 1, players do
    local card = encountersDeck.takeObject({guid = encountersCards[i]})
    table.insert(deckB, card)
  end

  -- adiciona 3 cartas de sala por herói e embaralha  
  for i = 1, players * 3 do
    local card = roomsDeck.takeObject({guid = roomsCards[i]})
    table.insert(deckB, card)
  end

  deckB = shuffle(deckB)
   
  -- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

  -- ## Passo C

  -- posiciona a sala de saída no final do deck
  table.insert(deckC, lair)

  -- adiciona 3 cards de sala
  for i = 1, 3 do
    local card = roomsDeck.takeObject({guid = roomsCards[i]})
    table.insert(deckC, card)
  end

  deckC = shuffle(deckC)

  -- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  -- Junta os decks
  for i = 1, #deckC do
    table.insert(finalDeck, deckC[i])
  end
  for i = 1, #deckB do
    table.insert(finalDeck, deckB[i])
  end
  for i = 1, #deckA do
    table.insert(finalDeck, deckA[i])
  end
 
  -- Coloca o deck final na posição
  for i = 1, #finalDeck do
    local card = finalDeck[i]
    card.flip()
    card.setPosition({ finalDeckZonePos.x , finalDeckZonePos.y + i + 2, finalDeckZonePos.z})
  end
 
  -- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  -- ## Pega os 4 primeiros tiles e coloca em volta do tile inicial
  finalDeck[#finalDeck].setPosition({ entrancePos.x - 3.2, entrancePos.y + 10, entrancePos.z })
  finalDeck[#finalDeck - 1].setPosition({ entrancePos.x + 3.2, entrancePos.y + 10, entrancePos.z })
  finalDeck[#finalDeck - 2].setPosition({ entrancePos.x, entrancePos.y + 10, entrancePos.z + 3.2 })
  finalDeck[#finalDeck - 3].setPosition({ entrancePos.x, entrancePos.y + 10, entrancePos.z - 3.2 })

end
 