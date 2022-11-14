ITEM.name = "NCR 재활용 파워 아머"
ITEM.description = "NCR 군대가 버려진 부품을 재활용해 수리한 T-45d 파워 아머로, 동력이 없어 사실상 무거운 강철 갑옷에 불과합니다."
ITEM.model = "models/mosi/fallout4/props/fortifications/vaultcrate04.mdl"
ITEM.width = 3
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(409.7919921875, 344.36294555664, 269),
	ang = Angle(25, 220, 0),
	fov = 8.5
}
ITEM.exRender = true
ITEM.armorAmount = 150
ITEM.price = 4200
ITEM.gasmask = false -- It will protect you from bad air
ITEM.resistance = true -- This will activate the protection bellow
ITEM.damage = { -- It is scaled; so 100 damage * 0.8 will makes the damage be 80.
			0.6, -- Bullets
			0.6, -- Slash
			0.6, -- Shock
			0.6, -- Burn
			0.9, -- Radiation
			1, -- Acid
			0.6, -- Explosion
}
ITEM.replacements = "models/player/ncr/hub/ncrheavy.mdl"

ITEM.maxDurability = 1075