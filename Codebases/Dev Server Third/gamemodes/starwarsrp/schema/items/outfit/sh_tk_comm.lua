ITEM.name = "Stormtrooper Commander Uniform"
ITEM.desc = "A stormtrooper commander uniform."
ITEM.category = "Outfit"
ITEM.model = "models/props_c17/BriefCase001a.mdl"
ITEM.width = 2
ITEM.height = 1
ITEM.outfitCategory = "model"
ITEM.pacData = {}
ITEM.replacements = "models/nate159/swbf2015/playermodels/stormtrooper.mdl"
ITEM.bodyGroups = {
	["Backpack"] = 1,
	["ShoulderPouches"] = 1,
	["Shoulderpad"] = 5
 }

/*
-- This will change a player's skin after changing the model. Keep in mind it starts at 0.
ITEM.newSkin = 1
-- This will change a certain part of the model.
ITEM.replacements = {"group01", "group02"}
-- This will change the player's model completely.
ITEM.replacements = "models/manhack.mdl"
-- This will have multiple replacements.
ITEM.replacements = {
	{"male", "female"},
	{"group01", "group02"}
}

-- This will apply body groups.
ITEM.bodyGroups = {
	["blade"] = 1,
	["bladeblur"] = 1
}
*/