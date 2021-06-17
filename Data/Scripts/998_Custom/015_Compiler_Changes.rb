module Compiler
  module_function

  #=============================================================================
  # Convert event name to item event.
  # Checks if the event's name is "Item:POTION" or "HiddenItem:POTION". If so,
  # rewrites the whole event into one now named "Item"/"HiddenItem" which gives
  # that item when interacted with.
  #=============================================================================
  def convert_to_item_event(event)
    return nil if !event || event.pages.length==0
    name = event.name
    ret       = RPG::Event.new(event.x,event.y)
    ret.name  = event.name
    ret.id    = event.id
    ret.pages = []
    itemName = ""
    hidden = false
    keyItem = false
    if name[/^hiddenitem\:\s*(\w+)\s*$/i]
      itemName = $1
      return nil if !GameData::Item.exists?(itemName)
      ret.name = "HiddenItem"
      hidden = true
    elsif name[/^item\:\s*(\w+)\s*$/i]
      itemName = $1
      return nil if !GameData::Item.exists?(itemName)
      ret.name = "Item"
    elsif name[/^keyitem\:\s*(\w+)\s*$/i]
        itemName = $1
        return nil if !GameData::Item.exists?(itemName)
        ret.name = "Key Item"
        keyItem = true;
    else
      return nil
    end
    # Event page 1
    if !keyItem
        page = RPG::Event::Page.new
        page.graphic.character_name = "Object ball" if !hidden
        page.list = []
        push_branch(page.list,sprintf("pbItemBall(:%s)",itemName))
        push_self_switch(page.list,"A",true,1)
        push_else(page.list,1)
        push_branch_end(page.list,1)
        push_end(page.list)
        ret.pages.push(page)
    else
            page = RPG::Event::Page.new
            page.graphic.character_name = "Object ball" if !hidden
            page.list = []
            push_branch(page.list,sprintf("pbGetKeyItem(:%s)",itemName))
            push_self_switch(page.list,"A",true,1)
            push_else(page.list,1)
            push_branch_end(page.list,1)
            push_end(page.list)
            ret.pages.push(page)
    end
    # Event page 2
    page = RPG::Event::Page.new
    page.condition.self_switch_valid = true
    page.condition.self_switch_ch    = "A"
    ret.pages.push(page)
    return ret
  end
end
