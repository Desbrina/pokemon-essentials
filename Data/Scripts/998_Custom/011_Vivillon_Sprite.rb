def pbVivillonSprite()
  
  $game_variables[106] = getVivillonFormName($game_variables[105])
  
  events = $game_map.events
  for i in 1..events.size
    event = events[i]
    name = event.name
  
    if name == "VivillonSprite"
      form = $game_variables[105]
      formImage = _INTL("666_{1}", form)
      if form > 0
        event.character_name=formImage
      else
        event.character_name="666"
      end
    end
  end
end

def getVivillonFormName(form = 0)
    forms = [:VIVILLON, :VIVILLON_1, :VIVILLON_2, :VIVILLON_3, :VIVILLON_4, :VIVILLON_5, :VIVILLON_6, :VIVILLON_7, :VIVILLON_8, :VIVILLON_9, :VIVILLON_10, :VIVILLON_11, :VIVILLON_12, :VIVILLON_13, :VIVILLON_14, :VIVILLON_15, :VIVILLON_16, :VIVILLON_17, :VIVILLON_18, :VIVILLON_19]
  species = forms[form]
  species_data = GameData::Species.get(species)
  
  return species_data.real_form_name
end
