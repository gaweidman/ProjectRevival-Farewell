ITEM.name = "Rebel Armor with Blue Undershirt"
ITEM.description = "A metropolice vest over top of a blue shirt."
ITEM.category = "Clothing"
ITEM.outfitCategory = "torso"
ITEM.model = "models/tnb/items/shirt_rebel1.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.bNoBodygroupReset = true
ITEM.dictionary = {"shirtArmor"}

ITEM.bodyGroups = {
    ["torso"] = 5,
}

function ITEM:CanEquipOutfit()
    if self.player:Team() == FACTION_CITIZEN or self.player:Team() == FACTION_CWU or self.player:Team() == FACTION_CMU then
   return true
else
   return false
   end
end