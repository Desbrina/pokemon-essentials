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
   # Changes: SHINY, IV, Hidden Ability, Pokerus
   chance = 1 #rand(1,5)
   if chance == 1
        if pkmn.shiny?
           scene.pbDisplay(_INTL("It won't have any effect."))
        else
           scene.pbDisplay(_INTL("{1} became shiny.",pkmn.name))
           pkmn.shiny = true
        end
   end
   pkmn.calc_stats
   next 1
})
