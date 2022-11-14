ITEM.name = "Gray Jeans"
ITEM.description = "A gray pair of jeans, made from cheap denim."
ITEM.category = "Clothing"
ITEM.outfitCategory = "legs"
ITEM.model = "models/tnb/items/pants_citizen.mdl"
ITEM.skin = 2
ITEM.width = 1
ITEM.height = 1
ITEM.bNoBodygroupReset = true
ITEM.dictionary = {"pants", "pantsJeans"}

ITEM.bodyGroups = {
    ["legs"] = 1,
}

function ITEM:CanEquipOutfit()
    if self.player:Team() == FACTION_CITIZEN or self.player:Team() == FACTION_CWU or self.player:Team() == FACTION_CMU then
   return true
else
   return false
   end
end