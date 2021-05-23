class PokemonMapEncountersScene2
  BASECOLOR   = Color.new(255,255,255)
  SHADOWCOLOR = Color.new(0,0,0)
  ICONSPERROW = 5

  def pbUpdate
    pbUpdateSpriteHash(@sprites)
  end

  def pbStartScene(mapID)
    @mapID=mapID
    @sprites={}
    @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z=99999
    addBackgroundPlane(@sprites,"bg","Custom/mapencounters",@viewport)
    @sprites["overlay"]=BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
    pbSetSystemFont(@sprites["overlay"].bitmap)
    pbDrawText
    pbFadeInAndShow(@sprites) { pbUpdate }
  end

  def pbDrawText
    havespecies = []
    seen        = 0
    caught      = 0
    encdata=load_data("Data/encounters.dat")
    encounters=encdata[@mapID] rescue nil
    
    encounter_data = GameData::Encounter.get(@mapID, $PokemonGlobal.encounter_version)
    if encounter_data
      encounters = Marshal.load(Marshal.dump(encounter_data.types))
    end
    
    if encounters
      # Get all encounterable species
      for encType in encounters
        next if !encType
        for encounter in encType[1]
          species=encounter[1]
          next if havespecies.include?(species) # No duplicates
          havespecies.push(species)
        end
      end
      # Sort species by National Dex number
      havespecies.sort!{|a,b| a<=>b }
      # Display all species (if there are any)
      if havespecies.length>0
        for i in 0...havespecies.length
          species=havespecies[i]
          species_data = GameData::Species.get(species)
          
          # Show mapencounters-iconback
          @sprites["back#{i}"]=IconSprite.new(24+100*(i%ICONSPERROW),
                                              80+100*(i/ICONSPERROW).floor,
                                              @viewport)
          @sprites["back#{i}"].setBitmap("Graphics/Pictures/Custom/mapencounters-iconback")
          # Show Pokémon icon
          @sprites["icon#{i}"]=PokemonSpeciesIconSprite.new(species,@viewport)
          @sprites["icon#{i}"].pbSetParams(species,0,species_data.form,false)
          @sprites["icon#{i}"].x=24+100*(i%ICONSPERROW)
          @sprites["icon#{i}"].y=80+100*(i/ICONSPERROW).floor
          # Show caught/uncaught icon - seen_form?(species, gender, form)
          @sprites["caught#{i}"]=IconSprite.new(24+100*(i%ICONSPERROW),
                                                80+100*(i/ICONSPERROW).floor,
                                                @viewport)
                                                
          @sprites["caught#{i}"].setBitmap("Graphics/Pictures/Custom/mapencounters-notcaught")

          owned = $Trainer.owned?(species)
          seenFormM = $Trainer.pokedex.seen_form?(species,0,species_data.form)
          seenFormF = $Trainer.pokedex.seen_form?(species,1,species_data.form)
          
          if owned && (seenFormM || seenFormF)
            @sprites["caught#{i}"].setBitmap("Graphics/Pictures/Custom/mapencounters-caught")
            seen+=1; caught+=1
          elsif $Trainer.pokedex.seen_form?(species,0,species_data.form)
            seen+=1
          else
            @sprites["icon#{i}"].tone=Tone.new(-255,-255,-255) # Blacked out
          end
        end
        pbDrawTextPositions(@sprites["overlay"].bitmap,[
           [_INTL("{1}",pbGetMapNameFromId(@mapID)),10,0,0,BASECOLOR,SHADOWCOLOR],
           [_INTL("Total: {1} - Seen: {2} - Caught: {3}",havespecies.length,seen,caught),10,32,0,BASECOLOR,SHADOWCOLOR],
        ])
      else
        pbDrawTextPositions(@sprites["overlay"].bitmap,[
           [_INTL("{1}",pbGetMapNameFromId(@mapID)),10,0,0,BASECOLOR,SHADOWCOLOR],
           [_INTL("No Pokémon found."),10,32,0,BASECOLOR,SHADOWCOLOR]
        ])
      end
    else
      pbDrawTextPositions(@sprites["overlay"].bitmap,[
         [_INTL("{1}",pbGetMapNameFromId(@mapID)),10,0,0,BASECOLOR,SHADOWCOLOR],
         [_INTL("No Pokémon found."),10,32,0,BASECOLOR,SHADOWCOLOR]
      ])
    end
  end

  def pbPokemonMapEncounters2
    loop do
      Graphics.update
      Input.update
      pbUpdate
      if Input.trigger?(Input::UP)
        break
      end
      if Input.trigger?(Input::DOWN)
        break
      end
      if Input.trigger?(Input::C)
        break
      end
      if Input.trigger?(Input::B)
        break
      end
    end
  end

  def pbEndScene
    pbFadeOutAndHide(@sprites) { pbUpdate }
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end
  
  def seen_form_any_gender?(species, form)
    ret = false
    if $Trainer.pokedex.seen_form?(species, 0, form) ||
      $Trainer.pokedex.seen_form?(species, 1, form)
      ret = true
    end
    return ret
  end

end



class PokemonMapEncounters2
  def initialize(scene)
    @scene=scene
  end

  def pbStartScreen(mapID)
    @scene.pbStartScene(mapID)
    @scene.pbPokemonMapEncounters2
    @scene.pbEndScene
  end
end



def pbMapEncounterChecker(mapID)
  pbFadeOutIn(99999) {
     scene=PokemonMapEncountersScene2.new
     screen=PokemonMapEncounters2.new(scene)
     screen.pbStartScreen(mapID)
  }
end
