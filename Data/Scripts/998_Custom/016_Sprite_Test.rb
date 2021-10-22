def pbSpriteTest()

    $game_variables[108] = Kernel.pbMessageFreeText(_INTL("Please enter a pokemon."), _INTL("{1}", $game_variables[108]),false,256,Graphics.width)
    $game_variables[108] = $game_variables[108].upcase
        
    choices=[
      _INTL("Normal"),
      _INTL("Shiny"),
      _INTL("Cancel")
    ]
    choice=Kernel.pbMessage(_INTL("{1}.", $game_variables[108]),choices,0)
    if choice == 0  # Normal
        $game_switches[107] = false # Shiny Switch
        
        $Trainer.party.delete_at(0)
        $Trainer.party.delete_at(0)
        $Trainer.party.delete_at(0)
        $Trainer.party.delete_at(0)
        $Trainer.party.delete_at(0)
        $Trainer.party.delete_at(0)
        
        pbAddPokemonSilent($game_variables[108],20)
        pbWildBattle($game_variables[108],5)
        
    elsif choice == 1 # Shiny
        $game_switches[107] = true # Shiny Switch
        
        $Trainer.party.delete_at(0)
        $Trainer.party.delete_at(0)
        $Trainer.party.delete_at(0)
        $Trainer.party.delete_at(0)
        $Trainer.party.delete_at(0)
        $Trainer.party.delete_at(0)
        
        pkmn = pbGenPkmn($game_variables[108],20)
        pkmn.shiny = true
        pbAddToPartySilent(pkmn)
        
        pbWildBattle($game_variables[108],5)
    else # Cancel
        
    end
end
