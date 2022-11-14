
ITEM.name = "Metal armor"
ITEM.description = "itemMetalArmorDesc"
ITEM.model = "models/props_c17/SuitCase_Passenger_Physics.mdl"
ITEM.height = 2
ITEM.width = 2
-- ITEM.armorAmount = 100
-- ITEM.price = 1100
ITEM.price = 460
ITEM.gasmask = false -- It will protect you from bad air
ITEM.resistance = true -- This will activate the protection bellow
ITEM.damage = { -- It is scaled; so 100 damage * 0.8 will makes the damage be 80.
			.64, -- Bullets
			.64, -- Slash
			.64, -- Shock
			.64, -- Burn
			1, -- Radiation
			1, -- Acid
			.64, -- Explosion
}
ITEM.replacements = {
	{"wastelander1", "metalarmour_mk1"},
	{"wastelander2", "metalarmour_mk1"},
	{"wastelander3", "metalarmour_mk1"}
}

ITEM.maxDurability = 500

ITEM.attribBoosts = {
	["stm"] = -1,
}