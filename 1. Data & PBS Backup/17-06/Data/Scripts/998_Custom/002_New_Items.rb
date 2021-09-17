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
