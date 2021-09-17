class UnownReport_Scene
  BASECOLOR   = Color.new(255,255,255)
  SHADOWCOLOR = Color.new(0,0,0)
  ICONSPERROW = 7
  UNOWNAMOUNT = 28

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
    for i in 0...UNOWNAMOUNT
      @sprites["icon#{i}"]=PokemonSpeciesIconSprite.new(201,@viewport)
      @sprites["icon#{i}"].pbSetParams(201,0,i)
      @sprites["icon#{i}"].x=24+70*(i%ICONSPERROW)
      @sprites["icon#{i}"].y=80+70*(i/ICONSPERROW).floor
      
      if !$Trainer.formseen[201][0][i]
        @sprites["icon#{i}"].tone=Tone.new(-255,-255,-255)
        j = j + 1
      end
      
    end
    
    caught = UNOWNAMOUNT - j
    pbDrawTextPositions(@sprites["overlay"].bitmap,[
           [_INTL("Unown Report"),10,0,0,BASECOLOR,SHADOWCOLOR],
           [_INTL("Total: {1} - Caught: {2}",UNOWNAMOUNT,caught),10,32,0,BASECOLOR,SHADOWCOLOR],
        ])
    
  end

  def pbUnownReport
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



class UnownReport
  def initialize(scene)
    @scene=scene
  end

  def pbStartScreen()
    @scene.pbStartScene()
    @scene.pbUnownReport
    @scene.pbEndScene
  end
end

def pbUnknownReportStart()
  scene=UnownReport_Scene.new
  screen=UnownReport.new(scene)
  ret=screen.pbStartScreen()
end
