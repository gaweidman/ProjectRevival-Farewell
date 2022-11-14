ITEM.name = "Brotherhood T-60a power armor"
ITEM.description = "itemT60PowerArmorBOSDesc"
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
-- ITEM.price = 10000
ITEM.price = 5760
ITEM.gasmask = false -- It will protect you from bad air
ITEM.resistance = true -- This will activate the protection bellow
ITEM.damage = { -- It is scaled; so 100 damage * 0.8 will makes the damage be 80.
			0.31, -- Bullets
			0.31, -- Slash
			0.31, -- Shock
			0.31, -- Burn
			0.68, -- Radiation
			1, -- Acid
			0.31, -- Explosion
}
ITEM.replacements = "models/adi/t601_lyonspride_pm.mdl"

ITEM.maxDurability = 2430

ITEM.attribBoosts = {
	["str"] = 2,
}