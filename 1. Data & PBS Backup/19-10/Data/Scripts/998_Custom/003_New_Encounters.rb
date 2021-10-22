GameData::EncounterType.register({
  :id             => :Event,
  :type           => :none,
  :trigger_chance => 21,
  :old_slots      => [20, 20, 10, 10, 10, 10, 5, 5, 4, 4, 1, 1]
})

GameData::EncounterType.register({
  :id             => :LeafPile,
  :type           => :none,
  :trigger_chance => 21,
  :old_slots      => [20, 20, 10, 10, 10, 10, 5, 5, 4, 4, 1, 1]
})

def pbLeafPile(event=nil)
  if pbConfirmMessage(_INTL("A Pokémon could be in this leaf pile. Would you like to check?"))
      pbLeafPileEffect(event)
    return true
  end
  return false
end

def pbLeafPileEffect(event=nil)
    if !pbEncounter(:LeafPile)
      pbMessage(_INTL("Nope. Nothing..."))
    end
end
