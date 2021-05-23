class VivillonReport_Scene
  BASECOLOR   = Color.new(255,255,255)
  SHADOWCOLOR = Color.new(0,0,0)
  ICONSPERROW = 5
  VivillonAMOUNT = 20

  def pbUpdate
    pbUpdateSpriteHash(@sprites)
  end

  def pbStartScene()
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
    # Show Pokémon icon
    i = 0
    j = 0
    species = :VIVILLON
    for i in 0...VivillonAMOUNT
      @sprites["icon#{i}"]=PokemonSpeciesIconSprite.new(species,@viewport)
      @sprites["icon#{i}"].pbSetParams(species,0,i,false)
      @sprites["icon#{i}"].x=15+100*(i%ICONSPERROW)
      @sprites["icon#{i}"].y=80+70*(i/ICONSPERROW).floor
      
      seenFormM = $Trainer.pokedex.seen_form?(species,0,i)
      seenFormF = $Trainer.pokedex.seen_form?(species,1,i)
      
      if !seenFormM && !seenFormF
        @sprites["icon#{i}"].tone=Tone.new(-255,-255,-255)
        j = j + 1
      end
      
    end
    
    caught = VivillonAMOUNT - j
    pbDrawTextPositions(@sprites["overlay"].bitmap,[
           [_INTL("Vivillon Report"),10,0,0,BASECOLOR,SHADOWCOLOR],
           [_INTL("Total: {1} - Caught: {2}",VivillonAMOUNT,caught),10,32,0,BASECOLOR,SHADOWCOLOR],
        ])
    
  end

  def pbVivillonReport
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
end



class VivillonReport
  def initialize(scene)
    @scene=scene
  end

  def pbStartScreen()
    @scene.pbStartScene()
    @scene.pbVivillonReport
    @scene.pbEndScene
  end
end

def pbVivillonReportStart()
  scene=VivillonReport_Scene.new
  screen=VivillonReport.new(scene)
  ret=screen.pbStartScreen()
end
