ITEM.name = "레이더 파워 아머"
ITEM.description = "대전쟁 중 미군이 전차 대용으로 개발한 강화복인 T-45d 파워 아머입니다.\n버려진 파워 아머를 수리하고 개성 있는 도색을 칠했습니다."
ITEM.model = "models/mosi/fallout4/props/fortifications/vaultcrate04.mdl"
ITEM.width = 3
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(409.7919921875, 344.36294555664, 269),
	ang = Angle(25, 220, 0),
	fov = 8.5
}
ITEM.exRender = true
ITEM.armorAmount = 200
ITEM.price = 5500
ITEM.gasmask = false -- It will protect you from bad air
ITEM.resistance = true -- This will activate the protection bellow
ITEM.damage = { -- It is scaled; so 100 damage * 0.8 will makes the damage be 80.
			0.65, -- Bullets
			0.65, -- Slash
			0.65, -- Shock
			0.65, -- Burn
			0.9, -- Radiation
			1, -- Acid
			0.65, -- Explosion
}
ITEM.replacements = "models/player/hub/neutrals/raiderpa/raiderpa.mdl"

ITEM.maxDurability = 750
