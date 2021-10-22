class RoamingReport_Scene
  BASECOLOR   = Color.new(255,255,255)
  SHADOWCOLOR = Color.new(0,0,0)
  ICONSPERROW = 5

  def pbUpdate
    pbUpdateSpriteHash(@sprites)
  end

  def pbStartScene()
    @sprites={}
    @index = 0
    @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z=99999
    addBackgroundPlane(@sprites,"bg","Custom/roamerreport",@viewport)
    @sprites["overlay"]=BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
    @sprites["rightarrow"] = AnimatedSprite.new("Graphics/Pictures/rightarrow",8,40,28,2,@viewport)
    @sprites["rightarrow"].x = Graphics.width - @sprites["rightarrow"].bitmap.width
    @sprites["rightarrow"].y = Graphics.height/2 - @sprites["rightarrow"].bitmap.height/16
    @sprites["rightarrow"].play
    @sprites["leftarrow"] = AnimatedSprite.new("Graphics/Pictures/leftarrow",8,40,28,2,@viewport)
    @sprites["leftarrow"].x = 0
    @sprites["leftarrow"].y = Graphics.height/2 - @sprites["rightarrow"].bitmap.height/16
    @sprites["leftarrow"].play
    pbSetSystemFont(@sprites["overlay"].bitmap)
    pbDrawText
    pbFadeInAndShow(@sprites) { pbUpdate }
  end
  
  def pbClear
        overlay=@sprites["overlay"].bitmap
        overlay.clear
        @sprites["pokemon1"].visible = false
        @sprites["pokemon2"].visible = false
  end

  def pbDrawText
      
      mapinfos = pbLoadMapInfos
      
    # Pokemon 1
    pos1 = @index+0
    pokemon = Settings::ROAMING_SPECIES[pos1][0]
    species_data = GameData::Species.get(pokemon)
    @sprites["pokemon1"] = PokemonSprite.new(@viewport)
    @sprites["pokemon1"].setOffset(PictureOrigin::Center)
    # Changed the position of Pokémon Battler
    @sprites["pokemon1"].x = 125
    @sprites["pokemon1"].y = 150
    @sprites["pokemon1"].setSpeciesBitmap(pokemon, 0, species_data.form)
    curmap1 = $PokemonGlobal.roamPosition[pos1]
    
    
      # Pokemon 2
      pos2 = @index+1
      pokemon = Settings::ROAMING_SPECIES[pos2][0]
      species_data = GameData::Species.get(pokemon)
      @sprites["pokemon2"] = PokemonSprite.new(@viewport)
      @sprites["pokemon2"].setOffset(PictureOrigin::Center)
      # Changed the position of Pokémon Battler
      @sprites["pokemon2"].x = 375
      @sprites["pokemon2"].y = 150
      @sprites["pokemon2"].setSpeciesBitmap(pokemon, 0, species_data.form)
      curmap2 = $PokemonGlobal.roamPosition[pos2]
      
      p $PokemonGlobal.roamPokemon[pos1]
      p $PokemonGlobal.roamPokemonCaught[pos1]
    
    pbDrawTextPositions(@sprites["overlay"].bitmap,[
           [_INTL("Roaming Report"),9,0,0,BASECOLOR,SHADOWCOLOR],
           [_INTL("{1}", mapinfos[curmap1].name),40,250,0,BASECOLOR,SHADOWCOLOR],
           [_INTL("{1}", mapinfos[curmap2].name),275,250,0,BASECOLOR,SHADOWCOLOR],
        ])
    
  end

  def pbRoamingReport
    loop do
      Graphics.update
      Input.update
      pbUpdate
      if Input.trigger?(Input::RIGHT)
          @index += 2
          if @index >= Settings::ROAMING_SPECIES.length
              @index -= 2
          end
          pbClear
          pbDrawText
      end
      if Input.trigger?(Input::LEFT)
          if @index >= 2
              @index -= 2
          end
          pbClear
          pbDrawText
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
end



class RoamingReport
  def initialize(scene)
    @scene=scene
  end

  def pbStartScreen()
    @scene.pbStartScene()
    @scene.pbRoamingReport
    @scene.pbEndScene
  end
end

def pbRoamingReportStart()
  scene=RoamingReport_Scene.new
  screen=RoamingReport.new(scene)
  ret=screen.pbStartScreen()
end
