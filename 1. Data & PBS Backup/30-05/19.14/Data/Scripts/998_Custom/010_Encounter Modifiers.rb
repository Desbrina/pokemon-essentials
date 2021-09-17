Events.onWildPokemonCreate+=proc {|sender,e|
   pokemon=e[0]
   if $game_switches[101] # 105 = VIVILLON Pattern
     pokemon.form=  $game_variables[105]
   end
}

Events.onWildPokemonCreate+=proc {|sender,e|
   pokemon=e[0]
   pokemon.makeShadow if $game_switches[103]
}
