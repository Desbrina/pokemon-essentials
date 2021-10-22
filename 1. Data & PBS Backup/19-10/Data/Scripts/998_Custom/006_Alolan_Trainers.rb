def pbAlolanTrainer(speciesName, pokeName, trainer, trainerName, gender)
  
  if pbGetSelfSwitch()
    Kernel.pbMessage(_INTL("Thanks"))
    return
  end
  
  Kernel.pbMessage(_INTL("Hi, I've come all the way from Alola to check out Pokémon here"))
  Kernel.pbMessage(_INTL("I'm looking to see a {1} from here, can you show me one?", pokeName))
  
  pbChoosePokemon(1,2,proc {|poke|poke.species==speciesName && poke.form==0})
  
  if pbGet(1) < 0
    Kernel.pbMessage(_INTL("Please show me a {1}", pokeName))
    return
  end
  
  choices=[
    _INTL("Yes"),
    _INTL("No")
  ]
  choice=Kernel.pbMessage("Wow, would you be up for a battle?",choices,0)
  if choice == 1
    Kernel.pbMessage(_INTL("Please come back if you change your mind"))
    return
  end
  
  pbTrainerBattle(trainer,trainerName,_I("Wow..."),false,0,false,0)
  
  choice=Kernel.pbMessage("Would you like to trade yours for mine?",choices,0)
  if choice == 1
    Kernel.pbMessage(_INTL("Come back if you change your mind"))
  end
  
  pbChoosePokemon(1,2,proc {|poke|poke.species==speciesName && poke.form==0})

  poke=PokeBattle_Pokemon.new(speciesName,pbGetPokemon(1).level,$Trainer)
  poke.form=1
  poke.resetMoves
  poke.calcStats

  pbStartTrade(pbGet(1),poke,pokeName,trainerName,gender)
  
  pbChangeSelfSwitch()
end

def pbChangeSelfSwitch()
  for event in $game_map.events.values
    if event.name[/Alolan/]
      $game_self_switches[[$game_map.map_id,event.id,"A"]] = true
    end
  end
  $game_map.need_refresh = true
end
  
def pbGetSelfSwitch()
  for event in $game_map.events.values
    if event.name[/Alolan/]
      return $game_self_switches[[$game_map.map_id,event.id,"A"]]
    end
  end
end

