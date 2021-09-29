def apricornTree(colour)
    e = get_character(0)
    frontSprite = _INTL("apricorntree_{1}_front", colour)
    leftSprite = _INTL("apricorntree_{1}_left", colour)
    rightSprite = _INTL("apricorntree_{1}_right", colour)
    backSprite = _INTL("apricorntree_{1}_back", colour)
    graphic = frontSprite
    
    case $game_player.direction
        when 2 # Down
        graphic=backSprite
        when 4 # Left
        graphic=rightSprite
        when 6 # Right
        graphic=leftSprite
        when 8 # Up
        graphic=frontSprite
    end
    
    pbMoveRoute($e,[
        PBMoveRoute::Graphic,graphic,0,2,0,
        PBMoveRoute::Wait,3,
        ],true
      )
    
    pbMoveRoute(e,[
        PBMoveRoute::Graphic,graphic,0,2,0,
        PBMoveRoute::Wait,3,
        PBMoveRoute::Graphic,graphic,0,2,1,
        PBMoveRoute::Wait,3,
        PBMoveRoute::Graphic,graphic,0,2,2,
        PBMoveRoute::Wait,3,
        PBMoveRoute::Graphic,graphic,0,2,3,
        PBMoveRoute::Wait,3,
        PBMoveRoute::Graphic,graphic,0,4,0,
        PBMoveRoute::Wait,3,
        PBMoveRoute::Graphic,graphic,0,4,1,
        PBMoveRoute::Wait,3,
        PBMoveRoute::Graphic,graphic,0,4,2,
        PBMoveRoute::Wait,3,
        PBMoveRoute::Graphic,graphic,0,4,3,
        PBMoveRoute::Wait,3,
        PBMoveRoute::Graphic,graphic,0,6,0,
        PBMoveRoute::Wait,3,
        PBMoveRoute::Graphic,graphic,0,6,1,
        PBMoveRoute::Wait,3,
        PBMoveRoute::Graphic,graphic,0,6,2,
        PBMoveRoute::Wait,3,
        PBMoveRoute::Graphic,graphic,0,6,3,
        PBMoveRoute::Wait,3,
        PBMoveRoute::Graphic,graphic,0,8,0,
        PBMoveRoute::Wait,3,
        PBMoveRoute::Graphic,graphic,0,8,1,
        PBMoveRoute::Wait,3,
        PBMoveRoute::Graphic,graphic,0,8,2,
        PBMoveRoute::Wait,3,
        PBMoveRoute::Graphic,graphic,0,8,3,
        PBMoveRoute::Wait,3,
        PBMoveRoute::Graphic,graphic,0,6,0,
        ],true
      )
    
    case colour
        when "blue"
        Kernel.pbItemBall(:BLUEAPRICORN)
        when "red"
        Kernel.pbItemBall(:REDAPRICORN)
        when "yellow"
        Kernel.pbItemBall(:YELLOWAPRICORN)
        when "black"
        Kernel.pbItemBall(:BLACKAPRICORN)
        when "white"
        Kernel.pbItemBall(:WHITEAPRICORN)
        when "green"
        Kernel.pbItemBall(:GREENAPRICORN)
        when "pink"
        Kernel.pbItemBall(:PINKAPRICORN)
    end
end
