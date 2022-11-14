ITEM.name = "Black Beanie"
ITEM.description = "A black knit beanie that only fits men."
ITEM.category = "Clothing"
ITEM.outfitCategory = "beanie"
ITEM.model = "models/tnb/items/beanie.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.bNoBodygroupReset = true
ITEM.dictionary = {"beanie"}

ITEM.bodyGroups = {
    ["beanies"] = 1,
}

function ITEM:CanEquipOutfit()
    if self.player:Team() == FACTION_CITIZEN or self.player:Team() == FACTION_CWU or self.player:Team() == FACTION_CMU and !self.player:IsFemale() then
   return true
else
   return false
   end
end