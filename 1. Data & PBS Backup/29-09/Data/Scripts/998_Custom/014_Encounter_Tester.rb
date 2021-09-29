def pbEncounterTester()
    havespecies = []
    
    encounter_data = GameData::Encounter.get($game_map.map_id, $PokemonGlobal.encounter_version)
    if encounter_data
      encounters = Marshal.load(Marshal.dump(encounter_data.types))
    end

    if encounters
        for encType in encounters
            next if !encType
            for encounter in encType[1]
                species=encounter[1]
                next if havespecies.include?(species) # No duplicates
                havespecies.push(species)
            end
        end

        havespecies.sort!{|a,b| a<=>b }
        choices = []

        if havespecies.length>0
            for i in 0...havespecies.length
                species=havespecies[i]
                species_data = GameData::Species.get(species)
                choices.push(species_data.name)
            end

            poke = Kernel.pbMessage("Select a pokemon",choices,0)
            chosen = choices[poke]
            
            for i in 0...havespecies.length
                species=havespecies[i]
                species_data = GameData::Species.get(species)
                if chosen == species_data.name
                    pbWildBattle(species,15)
                end
            end
        end
    end
end
