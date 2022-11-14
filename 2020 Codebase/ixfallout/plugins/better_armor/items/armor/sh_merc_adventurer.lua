
ITEM.name = "Merc adventurer outfit"
ITEM.description = "itemMercAdventurerOutfitDesc"
ITEM.model = "models/props_c17/SuitCase_Passenger_Physics.mdl"
ITEM.width = 2
ITEM.height = 2
-- ITEM.armorAmount = 60
ITEM.price = 50
ITEM.gasmask = false -- It will protect you from bad air
ITEM.resistance = false -- This will activate the protection bellow
ITEM.damage = { -- It is scaled; so 100 damage * 0.8 will makes the damage be 80.
			.88, -- Bullets
			.88, -- Slash
			.88, -- Shock
			.88, -- Burn
			1, -- Radiation
			1, -- Acid
			.88, -- Explosion
}

ITEM.replacements = {
	{"player/neutral/hub", "hub/extra"},
	{"wastelander1", "merc_adventurer"},
	{"wastelander2", "merc_adventurer"},
	{"wastelander3", "merc_adventurer"},
	{"04", "01"},
	{"07", "01"},
	{"female_ghoul", "female_01"},
	{"01", "09"},
	{"05", "09"},
	{"male_ghoul", "male_01"},
}

ITEM.maxDurability = 100