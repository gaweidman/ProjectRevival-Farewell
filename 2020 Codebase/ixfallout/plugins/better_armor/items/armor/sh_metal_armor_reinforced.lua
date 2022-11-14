
ITEM.name = "Metal armor, reinforced"
ITEM.description = "itemMetalArmorReinforcedDesc"
ITEM.model = "models/props_c17/SuitCase_Passenger_Physics.mdl"
ITEM.height = 2
ITEM.width = 2
ITEM.armorAmount = 160
ITEM.price = 3500
ITEM.gasmask = false -- It will protect you from bad air
ITEM.resistance = true -- This will activate the protection bellow
ITEM.damage = { -- It is scaled; so 100 damage * 0.8 will makes the damage be 80.
			1, -- Bullets
			1, -- Slash
			1, -- Shock
			1, -- Burn
			1, -- Radiation
			1, -- Acid
			1, -- Explosion
}
ITEM.replacements = {
	{"wastelander1", "metalarmour_mk2"},
	{"wastelander2", "metalarmour_mk2"},
	{"wastelander3", "metalarmour_mk2"}
}

ITEM.maxDurability = 250

ITEM.attribBoosts = {
	["stm"] = -1,
}