ITEM.name = "Conscript Armor"
ITEM.description = "A camouflage flak jacket with the UU Claw printed on the back."
ITEM.category = "Outfit"
ITEM.model = "models/props_c17/BriefCase001a.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.outfitCategory = "model"
ITEM.isGasMask = true
ITEM.pacData = {}

ITEM.replacements = {
	{"artnovest", "art"},
	{"erdimnovest", "erdim"},
	{"ericnovest", "eric"},
	{"joenovest", "joe"},
	{"mikenovest", "mike"},
	{"sandronovest", "sandro"},
	{"tednovest", "ted"},
	{"vannovest", "van"},
	{"vancenovest", "vance"}
}

ITEM.bodyGroups = {
	["bodyarmor"] = 1
}

--[[
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
]]--