# VIVILLON Pattern
Events.onWildPokemonCreate+=proc {|sender,e|
   pokemon=e[0]
   if $game_switches[101]
     pokemon.form=  $game_variables[105]
   end
}

# Shadow Pokemon
Events.onWildPokemonCreate+=proc {|sender,e|
   pokemon=e[0]
   pokemon.makeShadow if $game_switches[103]
}
