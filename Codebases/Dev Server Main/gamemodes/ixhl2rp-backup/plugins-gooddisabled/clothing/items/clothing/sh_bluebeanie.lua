ITEM.name = "Blue Beanie"
ITEM.description = "A blue knit beanie that only fits men."
ITEM.category = "Clothing"
ITEM.outfitCategory = "beanie"
ITEM.model = "models/tnb/items/beanie.mdl"
ITEM.skin = 1
ITEM.width = 1
ITEM.height = 1
ITEM.bNoBodygroupReset = true

ITEM.replacements = {
	{"_extended", "_b_extended"}
}

function ITEM:CanEquipOutfit()
    if self.player:Team() == FACTION_CITIZEN or self.player:Team() == FACTION_CWU or self.player:Team() == FACTION_CMU and self.player:IsFemale() then
   return true
else
   return false
   end
end