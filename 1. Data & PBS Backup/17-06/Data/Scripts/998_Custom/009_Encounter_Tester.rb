def pbEncounterTester()
  if $game_switches[51]
    encdata=load_data("Data/encounters_2.dat")
  elsif $game_switches[169]
    encdata=load_data("Data/encounters_ghosts.dat")
  else
    encdata=load_data("Data/encounters.dat")
  end
  encounters=encdata[$game_map.map_id] rescue nil
  havespecies = []
  if encounters
    # Get all encounterable species
    for encType in encounters[1]
      next if !encType
      for encounter in encType
        species=encounter[0]
        next if havespecies.include?(species) # No duplicates
        havespecies.push(species)
      end
    end
    # Sort species by National Dex number
    havespecies.sort!{|a,b| a<=>b }
    # Display all species (if there are any)
    if havespecies.length>0
      choices = []
      for i in 0...havespecies.length
        species=havespecies[i]
        choices.push(PBSpecies.getName(species))
      end
      poke = Kernel.pbMessage("Select a pokemon",choices,0)
      chosen = choices[poke]
      specieNum = pbGetSpeciesNumber(chosen)
      
      for encType in encounters[1]
        next if !encType
        for encounter in encType
          species=encounter[0]
          if species == specieNum
            level=encounter[2]+rand(1+encounter[3]-encounter[2])
            
            pbWildBattle(specieNum, level)
          end
        end
      end
    end
  end
end

def pbGetSpeciesNumber(name)
  for i in 0..PBSpecies.maxValue
    if PBSpecies.getName(i) == name
      return i
    end
  end
  return false
end
