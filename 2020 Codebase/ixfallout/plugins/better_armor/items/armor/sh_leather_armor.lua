
ITEM.name = "Leather armor"
ITEM.description = "itemLeatherArmorDesc2"
ITEM.model = "models/props_c17/SuitCase_Passenger_Physics.mdl"
ITEM.height = 2
ITEM.width = 2
-- ITEM.armorAmount = 60
ITEM.price = 160
ITEM.gasmask = false -- It will protect you from bad air
ITEM.resistance = false -- This will activate the protection bellow
ITEM.damage = { -- It is scaled; so 100 damage * 0.8 will makes the damage be 80.
			.76, -- Bullets
			.76, -- Slash
			.76, -- Shock
			.76, -- Burn
			1, -- Radiation
			1, -- Acid
			.76, -- Explosion
}

ITEM.replacements = {
	{"neutral/hub", "hub/neutrals"},
	{"wastelander1_", ""},
	{"wastelander2_", ""},
	{"wastelander3_", ""},
	{"male_", "leather/"},
	{"01", "leathereasy"},
	{"05", "leathereasy"},
	{"09", "leathereasy"},
	{"ghoul", "leathereasy_ghoul"}
}

ITEM.maxDurability = 150