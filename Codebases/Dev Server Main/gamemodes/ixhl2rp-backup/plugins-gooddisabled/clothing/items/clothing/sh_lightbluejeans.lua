ITEM.name = "Light Blue Jeans"
ITEM.description = "A light blue pair of jeans, made from cheap denim."
ITEM.category = "Clothing"
ITEM.outfitCategory = "legs"
ITEM.model = "models/tnb/items/pants_citizen.mdl"
ITEM.skin = 1
ITEM.width = 1
ITEM.height = 1
ITEM.bNoBodygroupReset = true

ITEM.bodyGroups = {
    ["legs"] = 2,
}

function ITEM:CanEquipOutfit()
    if self.player:Team() == FACTION_CITIZEN or self.player:Team() == FACTION_CWU or self.player:Team() == FACTION_CMU then
   return true
else
   return false
   end
end