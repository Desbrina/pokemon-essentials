def pbEvolveTrading()
  choices=[
    _INTL("Yes"),
    _INTL("No")
  ]
  choice=Kernel.pbMessage("Would you like me to evolve one of your pokemon?",choices,0)
  if choice == 0
          
    pbChoosePokemon(1,2,
      proc {|poke|
      poke.species==PBSpecies::BOLDORE ||
      poke.species==PBSpecies::CLAMPERL ||
      poke.species==PBSpecies::DUSCLOPS ||
      poke.species==PBSpecies::ELECTABUZZ ||
      poke.species==PBSpecies::FEEBAS ||
      poke.species==PBSpecies::GRAVELER ||
      poke.species==PBSpecies::GURDURR ||
      poke.species==PBSpecies::HAUNTER ||
      poke.species==PBSpecies::KADABRA ||
      poke.species==PBSpecies::KARRABLAST ||
      poke.species==PBSpecies::MACHOKE ||
      poke.species==PBSpecies::MAGMAR ||
      poke.species==PBSpecies::ONIX ||
      poke.species==PBSpecies::PHANTUMP ||
      poke.species==PBSpecies::POLIWHIRL ||
      poke.species==PBSpecies::PORYGON ||
      poke.species==PBSpecies::PORYGON2 ||
      poke.species==PBSpecies::PUMPKABOO ||
      poke.species==PBSpecies::RHYDON ||
      poke.species==PBSpecies::SCYTHER ||
      poke.species==PBSpecies::SEADRA ||
      poke.species==PBSpecies::SHELMET ||
      poke.species==PBSpecies::SLOWPOKE ||
      poke.species==PBSpecies::SPRITZEE ||
      poke.species==PBSpecies::SWIRLIX
      })
      
    if pbGet(1) > 0
    
      pokemon = $Trainer.pokemonParty[pbGet(1)]
      po = $Trainer.pokemonParty[pbGet(1)]
      
      pbStartTrade(pbGet(1), PBSpecies::RATTATA, "Rattata","Melvin")
        
      Kernel.pbMessage("Thanks, now to trade back")
    
      pbStartTradeEvo(pbGet(1), pokemon, "Melvin")
      
    end
  end
  
end
    
def pbStartTradeEvo(pokemonIndex,newpoke,name)
  myPokemon=$Trainer.party[pokemonIndex]
  opponent=PokeBattle_Trainer.new($Trainer.name,$Trainer.gender)
  yourPokemon=nil; resetmoves=true
  if newpoke.is_a?(PokeBattle_Pokemon)
    yourPokemon=newpoke
  else
    if newpoke.is_a?(String) || newpoke.is_a?(Symbol)
      raise _INTL("Species does not exist ({1}).",newpoke) if !hasConst?(PBSpecies,newpoke)
      newpoke=getID(PBSpecies,newpoke)
    end
    yourPokemon=PokeBattle_Pokemon.new(newpoke,myPokemon.level,opponent)
  end
  yourPokemon.pbRecordFirstMoves
  $Trainer.seen[yourPokemon.species]=true
  $Trainer.owned[yourPokemon.species]=true
  pbSeenForm(yourPokemon)
  pbFadeOutInWithMusic(99999){
    evo=PokemonTrade_Scene.new
    evo.pbStartScreen(myPokemon,yourPokemon,$Trainer.name,name)
    evo.pbTrade
    evo.pbEndScreen
  }
  $Trainer.party[pokemonIndex]=yourPokemon
end
