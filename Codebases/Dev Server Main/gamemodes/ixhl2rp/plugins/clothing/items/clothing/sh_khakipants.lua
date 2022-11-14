ITEM.name = "Khakis"
ITEM.description = "The perfect pants for any State Farm employee."
ITEM.category = "Clothing"
ITEM.outfitCategory = "legs"
ITEM.model = "models/tnb/items/pants_citizen.mdl"
ITEM.skin = 2
ITEM.width = 1
ITEM.height = 1
ITEM.bNoBodygroupReset = true
ITEM.dictionary = {"pants"}

ITEM.bodyGroups = {
    ["legs"] = 5,
}

function ITEM:CanEquipOutfit()
    if self.player:Team() == FACTION_CITIZEN or self.player:Team() == FACTION_CWU or self.player:Team() == FACTION_CMU then
   return true
else
   return false
   end
end