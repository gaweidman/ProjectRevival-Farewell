ITEM.name = "Enclave power armor"
ITEM.description = "itemEnclavePowerArmorDesc"
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
ITEM.price = 890
ITEM.gasmask = false -- It will protect you from bad air
ITEM.resistance = true -- This will activate the protection bellow
ITEM.damage = { -- It is scaled; so 100 damage * 0.8 will makes the damage be 80.
			0.51, -- Bullets
			0.51, -- Slash
			0.51, -- Shock
			0.51, -- Burn
			0.8, -- Radiation
			1, -- Acid
			0.51, -- Explosion
}
ITEM.replacements = "models/player/enclave/hub/enclave_trooper.mdl"

ITEM.maxDurability = 1275

ITEM.attribBoosts = {
	["str"] = 2,
	["stm"] = -1,
}