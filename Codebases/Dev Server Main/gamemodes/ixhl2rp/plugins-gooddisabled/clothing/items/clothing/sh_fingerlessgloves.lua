ITEM.name = "Fingerless Gloves"
ITEM.description = "A pair of fingerless gloves with a velcro strap on the wrist."
ITEM.category = "Clothing"
ITEM.outfitCategory = "hands"
ITEM.model = "models/tnb/items/gloves.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.bNoBodygroupReset = true

ITEM.bodyGroups = {
    ["hands"] = 1,
}

function ITEM:CanEquipOutfit()
    if self.player:Team() == FACTION_CITIZEN or self.player:Team() == FACTION_CWU or self.player:Team() == FACTION_CMU then
   return true
else
   return false
   end
end