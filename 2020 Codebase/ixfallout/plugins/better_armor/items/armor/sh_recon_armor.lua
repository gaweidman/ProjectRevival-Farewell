
ITEM.name = "Recon armor"
ITEM.description = "itemReconArmorDesc"
ITEM.model = "models/Items/item_item_crate.mdl"
ITEM.height = 2
ITEM.width = 2
ITEM.armorAmount = 170
ITEM.price = 7240
ITEM.gasmask = false -- It will protect you from bad air
ITEM.resistance = false -- This will activate the protection bellow
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
	{"player/neutral/hub", "reconarmor"},
	{"wastelander1_male", "reconarmor"},
	{"wastelander2_male", "reconarmor"},
	{"wastelander3_male", "reconarmor"},
}

ITEM.maxDurability = 440