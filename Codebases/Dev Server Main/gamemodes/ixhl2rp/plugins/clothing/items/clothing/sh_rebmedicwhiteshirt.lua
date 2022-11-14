ITEM.name = "Rebel Medic Armor with White Undershirt"
ITEM.description = "A metropolice vest over top of a white shirt with red cross armbands."
ITEM.category = "Clothing"
ITEM.outfitCategory = "torso"
ITEM.model = "models/tnb/items/shirt_rebel1.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.bNoBodygroupReset = true
ITEM.dictionary = {"shirtArmor"}

ITEM.bodyGroups = {
    ["torso"] = 7,
}

function ITEM:CanEquipOutfit()
    if self.player:Team() == FACTION_CITIZEN or self.player:Team() == FACTION_CWU or self.player:Team() == FACTION_CMU then
   return true
else
   return false
   end
end