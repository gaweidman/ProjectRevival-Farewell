ITEM.name = "Sweatpants"
ITEM.description = "Sure, they're Union approved, but they really should be illegal."
ITEM.category = "Clothing"
ITEM.outfitCategory = "legs"
ITEM.model = "models/tnb/items/pants_citizen.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.bNoBodygroupReset = true

ITEM.bodyGroups = {
    ["legs"] = 6,
}

function ITEM:CanEquipOutfit()
    if self.player:Team() == FACTION_CITIZEN or self.player:Team() == FACTION_CWU or self.player:Team() == FACTION_CMU then
   return true
else
   return false
   end
end