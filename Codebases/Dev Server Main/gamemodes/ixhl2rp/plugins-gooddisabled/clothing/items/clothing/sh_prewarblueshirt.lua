ITEM.name = "Blue Pre-War Shirt"
ITEM.description = "A blue collared shirt that looks like it was part of a uniform."
ITEM.category = "Clothing"
ITEM.outfitCategory = "torso"
ITEM.model = "models/tnb/items/shirt_citizen1.mdl"
ITEM.skin = 1
ITEM.width = 1
ITEM.height = 1
ITEM.bNoBodygroupReset = true

ITEM.bodyGroups = {
    ["torso"] = 10,
}
function ITEM:CanEquipOutfit()
    if self.player:Team() == FACTION_CITIZEN or self.player:Team() == FACTION_CWU or self.player:Team() == FACTION_CMU then
   return true
else
   return false
   end
end