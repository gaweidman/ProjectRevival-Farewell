ITEM.name = "T-51b power armor"
ITEM.description = "itemT51BPowerArmorDesc"
ITEM.model = "models/mosi/fallout4/props/fortifications/vaultcrate04.mdl"
ITEM.width = 3
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(409.7919921875, 344.36294555664, 269),
	ang = Angle(25, 220, 0),
	fov = 8.5
}
ITEM.exRender = true
-- ITEM.armorAmount = 225
-- ITEM.price = 7200
ITEM.price = 1120
ITEM.gasmask = false -- It will protect you from bad air
ITEM.resistance = true -- This will activate the protection bellow
ITEM.damage = { -- It is scaled; so 100 damage * 0.8 will makes the damage be 80.
			0.4, -- Bullets
			0.4, -- Slash
			0.4, -- Shock
			0.4, -- Burn
			0.68, -- Radiation
			1, -- Acid
			0.4, -- Explosion
}
ITEM.replacements = "models/fallout_3/t51b.mdl"

ITEM.maxDurability = 2100

ITEM.attribBoosts = {
	["str"] = 1,
	["end"] = 1,
}