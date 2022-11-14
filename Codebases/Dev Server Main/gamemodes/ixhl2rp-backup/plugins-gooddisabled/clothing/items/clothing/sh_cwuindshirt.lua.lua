ITEM.name = "CWU Industrial Shirt"
ITEM.description = "A white collared shirt with a yellow label on its right sleeve."
ITEM.category = "Clothing"
ITEM.outfitCategory = "torso"
ITEM.model = "models/tnb/items/shirt_citizen1.mdl"
ITEM.skin = 2
ITEM.width = 1
ITEM.height = 1
ITEM.bNoBodygroupReset = true

ITEM.bodyGroups = {
    ["torso"] = 13,
}
function ITEM:CanEquipOutfit()
    if self.player:Team() == FACTION_CITIZEN or self.player:Team() == FACTION_CWU or self.player:Team() == FACTION_CMU then
   return true
else
   return false
   end
end