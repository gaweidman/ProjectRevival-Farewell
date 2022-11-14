ITEM.name = "Armored Gray Jeans"
ITEM.description = "A gray pair of jeans with armor padding on the side."
ITEM.category = "Clothing"
ITEM.outfitCategory = "legs"
ITEM.model = "models/tnb/items/pants_rebel.mdl"
ITEM.skin = 1
ITEM.width = 1
ITEM.height = 1
ITEM.bNoBodygroupReset = true

ITEM.bodyGroups = {
    ["legs"] = 4,
}

function ITEM:CanEquipOutfit()
    if self.player:Team() == FACTION_CITIZEN or self.player:Team() == FACTION_CWU or self.player:Team() == FACTION_CMU then
   return true
else
   return false
   end
end