PLUGIN.name = "Die Casts"
PLUGIN.author = "QIncarnate"
PLUGIN.description = "Adds die cast items for crafting."

--To add a new item or remove an item, this is the file to do it.

local ITEMS = {}

ITEMS.ninemmcast = {
	["name"] = "9mm Round Die Cast",
	["model"] = "models/illusion/eftcontainers/airfilter.mdl",
	["description"] = "A large die cast for 18 9mm rounds with two handles on either end.",
	["width"] = 1,
	["height"] = 1,
	["chance"] = 75 --This is used for the 'item spawner plugin' this defines how many 'tickets' the item gets to spawn.
}

ITEMS.smgroundcast = {
	["name"] = "4.6x30 Round Die Cast",
	["model"] = "models/illusion/eftcontainers/airfilter.mdl",
	["description"] = "A large die cast for 30 4.6x30 rounds with two handles on either end.",
	["width"] = 1,
	["height"] = 1,
	["chance"] = 75 --This is used for the 'item spawner plugin' this defines how many 'tickets' the item gets to spawn.
}

ITEMS.pythonroundcast = {
	["name"] = ".357 Round Die Cast",
	["model"] = "models/illusion/eftcontainers/airfilter.mdl",
	["description"] = "A large die cast for 12 .357 rounds with two handles on either end.",
	["width"] = 1,
	["height"] = 1,
	["chance"] = 75 --This is used for the 'item spawner plugin' this defines how many 'tickets' the item gets to spawn.
}

ITEMS.buckshotcast = {
	["name"] = "Shotgun Shell Head Die Cast",
	["model"] = "models/illusion/eftcontainers/airfilter.mdl",
	["description"] = "A large die cast for 12 shotgun shell heads  with two handles on either end.",
	["width"] = 1,
	["height"] = 1,
	["chance"] = 75 --This is used for the 'item spawner plugin' this defines how many 'tickets' the item gets to spawn.
}

ITEMS.grenadecast = {
	["name"] = "Grenade Body Die Cast",
	["model"] = "models/illusion/eftcontainers/airfilter.mdl",
	["description"] = "A large die cast for a grenade's body with two handles on either end.",
	["width"] = 1,
	["height"] = 1,
	["chance"] = 75 --This is used for the 'item spawner plugin' this defines how many 'tickets' the item gets to spawn.
}

for k, v in pairs(ITEMS) do
	local ITEM = ix.item.Register(k, nil, false, nil, true)
	ITEM.name = v.name
	ITEM.model = v.model
	ITEM.description = v.description
	ITEM.category = "Crafting"
	ITEM.width = v.width or 1
	ITEM.height = v.height or 1
	ITEM.chance = v.chance or 0
	ITEM.isTool = v.tool or false
end

ITEMS = {}