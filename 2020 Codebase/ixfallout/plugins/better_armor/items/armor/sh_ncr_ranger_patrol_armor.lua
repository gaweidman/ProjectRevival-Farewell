
ITEM.name = "NCR 레인저 정찰 아머"
ITEM.description = "NCR 군대의 정예병인 레인저들이 입는 복장입니다."
ITEM.model = "models/props_c17/SuitCase_Passenger_Physics.mdl"
ITEM.width = 2
ITEM.armorAmount = 150
ITEM.height = 2
ITEM.price = 390
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
	{"neutral/hub/wastelander1", "ncr/hub/rangerpatrol"},
	{"neutral/hub/wastelander2", "ncr/hub/rangerpatrol"},
	{"neutral/hub/wastelander3", "ncr/hub/rangerpatrol"},
	{"male_ghoul", "ghoul_male"},
	{"female_ghoul", "ghoul_female"}
}

ITEM.maxDurability = 500