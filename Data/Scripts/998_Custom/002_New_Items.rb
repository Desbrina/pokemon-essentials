ItemHandlers::UseFromBag.add(:ENCOUNTERCHECKER,proc{|item|
  scene=PokemonMapEncountersScene.new
  screen=PokemonMapEncounters.new(scene)
  ret=screen.pbStartScreen()
  next 1
})

ItemHandlers::UseInField.add(:ENCOUNTERCHECKER,proc{|item|
  scene=PokemonMapEncountersScene.new
  screen=PokemonMapEncounters.new(scene)
  ret=screen.pbStartScreen()
  next 1
})

ItemHandlers::UseFromBag.add(:UNOWNREPORT,proc{|item|
  pbUnknownReportStart()
  next 1
})

ItemHandlers::UseInField.add(:UNOWNREPORT,proc{|item|
  pbUnknownReportStart()
  next 1
})

ItemHandlers::UseFromBag.add(:VIVILLONREPORT,proc{|item|
  pbVivillonReportStart()
  next 1
})

ItemHandlers::UseInField.add(:VIVILLONREPORT,proc{|item|
  pbVivillonReportStart()
  next 1
})

ItemHandlers::UseFromBag.add(:ENCOUNTERTESTER,proc{|item|
  pbEncounterTester()
  next 1
})

ItemHandlers::UseInField.add(:ENCOUNTERTESTER,proc{|item|
  pbEncounterTester()
  next 1
})

ItemHandlers::UseFromBag.add(:POCKETPC,proc{|item|
  pbPokeCenterPC
  next 1
})

ItemHandlers::UseInField.add(:POCKETPC,proc{|item|
  pbPokeCenterPC
  next 1
})

ItemHandlers::UseOnPokemon.add(:SHIABERRY,proc { |item,pkmn,scene|
   #next pbHPItem(pkmn,10,scene)
   # Changes: SHINY, IV, Hidden Ability, Pokérus
   chance = 4 #rand(1,4)
   if chance == 1 # Shiny
        if pkmn.shiny?
           scene.pbDisplay(_INTL("It won't have any effect."))
        else
           scene.pbDisplay(_INTL("{1} became shiny.",pkmn.name))
           pkmn.shiny = true
        end
   end
   if chance == 2 # IV
                               
   end
   if chance == 3 # Hidden Ability
       pkmn.ability_index = 2
       scene.pbDisplay(_INTL("{1} got its hidden ability.",pkmn.name))
   end
   if chance == 4 # Pokérus
       pkmn.givePokerus
       scene.pbDisplay(_INTL("{1} got Pokérus.",pkmn.name))
   end
                               
   pkmn.calc_stats
   next 1
})
