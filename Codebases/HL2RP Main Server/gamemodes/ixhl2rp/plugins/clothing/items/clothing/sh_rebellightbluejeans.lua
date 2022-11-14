ITEM.name = "Armored Light Blue Jeans"
ITEM.description = "A light blue pair of jeans with armor padding on the side."
ITEM.category = "Clothing"
ITEM.outfitCategory = "legs"
ITEM.model = "models/tnb/items/pants_rebel.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.bNoBodygroupReset = true
ITEM.dictionary = {"pantsArmor"}

ITEM.bodyGroups = {
    ["legs"] = 3,
}

function ITEM:CanEquipOutfit()
    if self.player:Team() == FACTION_CITIZEN or self.player:Team() == FACTION_CWU or self.player:Team() == FACTION_CMU then
   return true
else
   return false
   end
end