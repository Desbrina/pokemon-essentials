BASECOLOR=Color.new(255,255,255)
SHADOWCOLOR=Color.new(0,0,0)

class Window_PokemonMapEncounters < Window_DrawableCommand
  def initialize(total,x,y,width,height,viewport=nil)
    @total = total
    super(x,y,width,height,viewport)
    @selarrow=AnimatedBitmap.new("Graphics/Pictures/Custom/mapSel")
    self.windowskin=nil
  end
  
  def getMapId(i)
    item=@total[i][1]
  end

  def itemCount
    return @total.length+1
  end

  def item
    return self.index>=@total.length ? 0 : @total[self.index]
  end

  def drawItem(index,count,rect)
    textpos=[]
    rect=drawCursor(index,rect)
    ypos=rect.y
    
    item=@total[index][0] if @total[index]!= nil
    item=@total[index] if @total[index]==nil
    if index==count-1
      textpos.push([_INTL("CANCEL"),rect.x,ypos+2,false,
         SHADOWCOLOR,BASECOLOR])
    else
      textpos.push([item,rect.x,ypos+2,false,
        BASECOLOR,SHADOWCOLOR])
    end
    pbDrawTextPositions(self.contents,textpos)
  end
end

class PokemonMapEncountersScene
  def update
    pbUpdateSpriteHash(@sprites)
  end

  def pbStartScene
    @total=0
    @index=0
    @sprites={}
    @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z=99999
    addBackgroundPlane(@sprites,"bg","Custom/mapencounters-list",@viewport)
    @sprites["overlay"]=BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
    pbSetSystemFont(@sprites["overlay"].bitmap)
    pbDrawText
    pbFadeInAndShow(@sprites) { update }
  end

  def pbDrawText
    overlay=@sprites["overlay"].bitmap
    overlay.clear
    
    maps = {} # hash containing the names of the maps
    
    mapinfos = pbLoadMapInfos
    for id in mapinfos.keys
      if $PokemonGlobal.visitedMaps[id] != nil
        if GameData::Encounter.exists?(id, $PokemonGlobal.encounter_version)
          maps[pbGetMapNameFromId(id)]=id
        end
      end
    end
  
    maps = maps.sort
    currentMap = pbGetMapNameFromId($game_map.map_id)
    index=0
    i=0
    for map in maps
      mapName = map[0]
      if mapName == currentMap
        index=i
      end
      i=i+1
    end
    
    @sprites["mapList"]=Window_PokemonMapEncounters.new(maps,
        10,40,Graphics.width,350,@viewport)
    @sprites["mapList"].viewport=@viewport
    
    @sprites["mapList"].index=index
    
    textPositions=[
       [_INTL("Select a Location"),10,0,0,BASECOLOR,SHADOWCOLOR],
    ]
    
    pbSetSystemFont(@sprites["overlay"].bitmap)
    if !textPositions.empty?
      pbDrawTextPositions(@sprites["overlay"].bitmap,textPositions)
    end
  end
  
  def pbPokemonMapEncounters
    loop do
      Graphics.update
      Input.update
      self.update
      if Input.trigger?(Input::B)
        break
      end
      if Input.trigger?(Input::C)
        index = @sprites["mapList"].index
        total = @sprites["mapList"].itemCount
        break if index == total-1
        mapId = @sprites["mapList"].getMapId(index)
        pbMapEncounterChecker(mapId)
      end
    end
  end

  def pbEndScene
    pbFadeOutAndHide(@sprites) { update }
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end
end

class PokemonMapEncounters
  def initialize(scene)
    @scene=scene
  end

  def pbStartScreen
    @scene.pbStartScene
    @scene.pbPokemonMapEncounters
    @scene.pbEndScene
  end
end
