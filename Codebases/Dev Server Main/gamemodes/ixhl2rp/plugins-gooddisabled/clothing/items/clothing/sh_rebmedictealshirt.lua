ITEM.name = "Rebel Medic Armor with Teal Undershirt"
ITEM.description = "A metropolice vest over top of a teal shirt with red cross armbands."
ITEM.category = "Clothing"
ITEM.outfitCategory = "torso"
ITEM.model = "models/tnb/items/shirt_rebel1.mdl"
ITEM.skin = 1
ITEM.width = 1
ITEM.height = 1
ITEM.bNoBodygroupReset = true

ITEM.bodyGroups = {
    ["torso"] = 8,
}
function ITEM:CanEquipOutfit()
    if self.player:Team() == FACTION_CITIZEN or self.player:Team() == FACTION_CWU or self.player:Team() == FACTION_CMU then
   return true
else
   return false
   end
end