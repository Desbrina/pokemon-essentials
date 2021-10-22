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

ItemHandlers::UseFromBag.add(:ROAMERREPORT,proc{|item|
  pbRoamingReportStart()
  next 1
})

ItemHandlers::UseInField.add(:ROAMERREPORT,proc{|item|
  pbRoamingReportStart()
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
   chance = rand(1,4)
   if chance == 1 # Shiny
        if pkmn.shiny?
           scene.pbDisplay(_INTL("It won't have any effect."))
        else
           scene.pbDisplay(_INTL("{1} became shiny.",pkmn.name))
           pkmn.shiny = true
        end
   end
   if chance == 2 # IV
      ivChance = rand(1, 6)
      if ivChance == 1 # Def
           pkmn.iv[:DEFENSE] = 31
           scene.pbDisplay(_INTL("{1} gained max IVs in Defense.",pkmn.name))
       end
       if ivChance == 2 #HP
           pkmn.iv[:HP] = 31
           scene.pbDisplay(_INTL("{1} gained max IVs in HP.",pkmn.name))
       end
       if ivChance == 3 #Attack
           pkmn.iv[:ATTACK] = 31
           scene.pbDisplay(_INTL("{1} gained max IVs in Attack.",pkmn.name))
       end
       if ivChance == 4 #Special Attack
           pkmn.iv[:SPECIAL_ATTACK] = 31
           scene.pbDisplay(_INTL("{1} gained max IVs in Special Attack.",pkmn.name))
       end
       if ivChance == 5 #Special Defense
           pkmn.iv[:SPECIAL_DEFENSE] = 31
           scene.pbDisplay(_INTL("{1} gained max IVs in Special Defense.",pkmn.name))
       end
       if ivChance == 6 #Speed
           pkmn.iv[:SPEED] = 31
           scene.pbDisplay(_INTL("{1} gained max IVs in Speed.",pkmn.name))
       end
   end
   if chance == 3 # Hidden Ability
       pkmn.ability_index = 2
       scene.pbDisplay(_INTL("{1} gained its hidden ability.",pkmn.name))
   end
   if chance == 4 # Pokérus
       pkmn.givePokerus
       scene.pbDisplay(_INTL("{1} got Pokérus.",pkmn.name))
   end
                               
   pkmn.calc_stats
   next 1
})
