ITEM.name = "Teal and Black Coat"
ITEM.description = "A teal and black winter coat with a zipper down the front."
ITEM.category = "Clothing"
ITEM.outfitCategory = "torso"
ITEM.model = "models/tnb/items/wintercoat.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.bNoBodygroupReset = true
ITEM.dictionary = {"coat"}

ITEM.bodyGroups = {
    ["torso"] = 16,
}
function ITEM:CanEquipOutfit()
    if self.player:Team() == FACTION_CITIZEN or self.player:Team() == FACTION_CWU or self.player:Team() == FACTION_CMU then
   return true
else
   return false
   end
end