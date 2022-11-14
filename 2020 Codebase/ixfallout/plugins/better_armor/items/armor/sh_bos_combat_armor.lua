
ITEM.name = "Brotherhood combat armor"
ITEM.description = "itemCombatArmorDesc"
ITEM.model = "models/props_c17/SuitCase_Passenger_Physics.mdl"
ITEM.height = 2
ITEM.width = 2
-- ITEM.armorAmount = 180
-- ITEM.price = 7300
ITEM.price = 440
ITEM.gasmask = false -- It will protect you from bad air
ITEM.resistance = false -- This will activate the protection bellow
ITEM.damage = { -- It is scaled; so 100 damage * 0.8 will makes the damage be 80.
			0.68, -- Bullets
			0.68, -- Slash
			0.68, -- Shock
			0.68, -- Burn
			1, -- Radiation
			1, -- Acid
			0.68, -- Explosion
}
ITEM.replacements = {
	{"neutral/hub/wastelander1", "bs/hub/recon"},
	{"neutral/hub/wastelander2", "bs/hub/recon"},
	{"neutral/hub/wastelander3", "bs/hub/recon"}
}

ITEM.maxDurability = 450