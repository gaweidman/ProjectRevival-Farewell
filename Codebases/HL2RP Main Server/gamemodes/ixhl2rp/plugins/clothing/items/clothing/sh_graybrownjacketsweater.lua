ITEM.name = "Gray and Brown Coat and Sweater"
ITEM.description = "A gray and brown jacket and a fleece sweater."
ITEM.category = "Clothing"
ITEM.outfitCategory = "torso"
ITEM.model = "models/tnb/items/wintercoat.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.bNoBodygroupReset = true
ITEM.dictionary = {"coatSweater"}

ITEM.bodyGroups = {
    ["torso"] = 20,
}
function ITEM:CanEquipOutfit()
    if self.player:Team() == FACTION_CITIZEN or self.player:Team() == FACTION_CWU or self.player:Team() == FACTION_CMU then
   return true
else
   return false
   end
end