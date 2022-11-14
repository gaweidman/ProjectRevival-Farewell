
ITEM.name = "Desert Ranger combat armor"
ITEM.description = "itemDesertRangerCombatArmorDesc"
ITEM.model = "models/props_c17/SuitCase_Passenger_Physics.mdl"
ITEM.width = 2
ITEM.armorAmount = 220
ITEM.height = 2
ITEM.price = 10500
ITEM.gasmask = false
ITEM.resistance = false
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
	{"wastelander1_female_01", "desranger_female_01"},
	{"wastelander1_female_04", "desranger_female_01"},
	{"wastelander1_female_07", "desranger_female_01"},
	{"wastelander1_female_ghoul", "desranger_female_01"},
	{"wastelander1_male_01", "desranger_male_09"},
	{"wastelander1_male_05", "desranger_male_09"},
	{"wastelander1_male_09", "desranger_male_09"},
	{"wastelander1_male_ghoul", "desranger_male_09"},
	{"wastelander2_female_01", "desranger_female_01"},
	{"wastelander2_female_04", "desranger_female_01"},
	{"wastelander2_female_07", "desranger_female_01"},
	{"wastelander2_female_ghoul", "desranger_female_01"},
	{"wastelander2_male_01", "desranger_male_09"},
	{"wastelander2_male_05", "desranger_male_09"},
	{"wastelander2_male_09", "desranger_male_09"},
	{"wastelander2_male_ghoul", "desranger_male_09"},
	{"wastelander3_female_01", "desranger_female_01"},
	{"wastelander3_female_04", "desranger_female_01"},
	{"wastelander3_female_07", "desranger_female_01"},
	{"wastelander3_female_ghoul", "desranger_female_01"},
	{"wastelander3_male_01", "desranger_male_09"},
	{"wastelander3_male_05", "desranger_male_09"},
	{"wastelander3_male_09", "desranger_male_09"},
	{"wastelander3_male_ghoul", "desranger_male_09"}
}

ITEM.maxDurability = 700