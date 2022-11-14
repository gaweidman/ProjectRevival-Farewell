
ITEM.name = "NCR 헌병 군복"
ITEM.description = "NCR 군대의 헌병들이 입는 군복입니다."
ITEM.model = "models/props_c17/SuitCase_Passenger_Physics.mdl"
ITEM.width = 2
ITEM.armorAmount = 20
ITEM.height = 2
ITEM.price = 350
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
	{"models/player/neutral/hub/wastelander1_male_01.mdl", "models/player/ncrmp/ncr_01.mdl"},
	{"models/player/neutral/hub/wastelander1_male_05.mdl", "models/player/ncrmp/ncr_05.mdl"},
	{"models/player/neutral/hub/wastelander1_male_09.mdl", "models/player/ncrmp/ncr_09.mdl"},
	{"models/player/neutral/hub/wastelander2_male_01.mdl", "models/player/ncrmp/ncr_01.mdl"},
	{"models/player/neutral/hub/wastelander2_male_05.mdl", "models/player/ncrmp/ncr_05.mdl"},
	{"models/player/neutral/hub/wastelander2_male_09.mdl", "models/player/ncrmp/ncr_09.mdl"},
	{"models/player/neutral/hub/wastelander3_male_01.mdl", "models/player/ncrmp/ncr_01.mdl"},
	{"models/player/neutral/hub/wastelander3_male_05.mdl", "models/player/ncrmp/ncr_05.mdl"},
	{"models/player/neutral/hub/wastelander3_male_09.mdl", "models/player/ncrmp/ncr_09.mdl"}
}

ITEM.maxDurability = 450