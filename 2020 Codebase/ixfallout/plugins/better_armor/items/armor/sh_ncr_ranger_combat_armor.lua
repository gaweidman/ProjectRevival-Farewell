
ITEM.name = "NCR 레인저 컴뱃 아머"
ITEM.description = "NCR 군대의 정예병인 레인저들이 입는 복장입니다."
ITEM.model = "models/props_c17/SuitCase_Passenger_Physics.mdl"
ITEM.width = 2
ITEM.armorAmount = 200
ITEM.height = 2
ITEM.price = 8499
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
	{"neutral/hub/wastelander1_female_01", "ncr/hub/ncrranger_female_01"},
	{"neutral/hub/wastelander1_female_04", "ncr/hub/ncrranger_female_01"},
	{"neutral/hub/wastelander1_female_07", "ncr/hub/ncrranger_female_01"},
	{"neutral/hub/wastelander1_female_ghoul", "ncr/hub/ncrranger_female_01"},
	{"neutral/hub/wastelander1_male_01", "ncr/hub/ncrranger_male_09"},
	{"neutral/hub/wastelander1_male_05", "ncr/hub/ncrranger_male_09"},
	{"neutral/hub/wastelander1_male_09", "ncr/hub/ncrranger_male_09"},
	{"neutral/hub/wastelander1_male_ghoul", "ncr/hub/ncrranger_male_09"},
	{"neutral/hub/wastelander2_female_01", "ncr/hub/ncrranger_female_01"},
	{"neutral/hub/wastelander2_female_04", "ncr/hub/ncrranger_female_01"},
	{"neutral/hub/wastelander2_female_07", "ncr/hub/ncrranger_female_01"},
	{"neutral/hub/wastelander2_female_ghoul", "ncr/hub/ncrranger_female_01"},
	{"neutral/hub/wastelander2_male_01", "ncr/hub/ncrranger_male_09"},
	{"neutral/hub/wastelander2_male_05", "ncr/hub/ncrranger_male_09"},
	{"neutral/hub/wastelander2_male_09", "ncr/hub/ncrranger_male_09"},
	{"neutral/hub/wastelander2_male_ghoul", "ncr/hub/ncrranger_male_09"},
	{"neutral/hub/wastelander3_female_01", "ncr/hub/ncrranger_female_01"},
	{"neutral/hub/wastelander3_female_04", "ncr/hub/ncrranger_female_01"},
	{"neutral/hub/wastelander3_female_07", "ncr/hub/ncrranger_female_01"},
	{"neutral/hub/wastelander3_female_ghoul", "ncr/hub/ncrranger_female_01"},
	{"neutral/hub/wastelander3_male_01", "ncr/hub/ncrranger_male_09"},
	{"neutral/hub/wastelander3_male_05", "ncr/hub/ncrranger_male_09"},
	{"neutral/hub/wastelander3_male_09", "ncr/hub/ncrranger_male_09"},
	{"neutral/hub/wastelander3_male_ghoul", "ncr/hub/ncrranger_male_09"}
}

ITEM.maxDurability = 700
