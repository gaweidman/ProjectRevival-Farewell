
ITEM.name = "NCR 의무병 전투복"
ITEM.description = "NCR 군대의 전투원들이 입는 군복입니다.\n전투모에 적십자 마크가 있습니다."
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
	{"neutral/hub/wastelander1_male", "ncr/hub/ncrmed"},
	{"neutral/hub/wastelander2_male", "ncr/hub/ncrmed"},
	{"neutral/hub/wastelander3_male", "ncr/hub/ncrmed"},
	{"neutral/hub/wastelander1_female", "ncr/hub/femalemed"},
	{"neutral/hub/wastelander2_female", "ncr/hub/femalemed"},
	{"neutral/hub/wastelander3_female", "ncr/hub/femalemed"}
}

ITEM.maxDurability = 450