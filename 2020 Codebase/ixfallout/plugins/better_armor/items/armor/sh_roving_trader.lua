
ITEM.name = "Roving trader outfit"
ITEM.description = "itemRovingTraderOutfitDesc"
ITEM.model = "models/props_c17/SuitCase_Passenger_Physics.mdl"
ITEM.width = 2
ITEM.height = 2
-- ITEM.armorAmount = 60
ITEM.price = 12
ITEM.gasmask = false -- It will protect you from bad air
ITEM.resistance = false -- This will activate the protection bellow
ITEM.damage = { -- It is scaled; so 100 damage * 0.8 will makes the damage be 80.
			.97, -- Bullets
			.97, -- Slash
			.97, -- Shock
			.97, -- Burn
			1, -- Radiation
			1, -- Acid
			.97, -- Explosion
}


ITEM.replacements = {
	{"neutral/hub/wastelander1", "hub/extra/rovingtrader"},
	{"neutral/hub/wastelander2", "hub/extra/rovingtrader"},
	{"neutral/hub/wastelander3", "hub/extra/rovingtrader"},
	{"04", "01"},
	{"07", "01"},
	{"female_ghoul", "female_01"},
	{"01", "09"},
	{"05", "09"},
	{"male_ghoul", "ghoul_male"},
}

ITEM.maxDurability = 110