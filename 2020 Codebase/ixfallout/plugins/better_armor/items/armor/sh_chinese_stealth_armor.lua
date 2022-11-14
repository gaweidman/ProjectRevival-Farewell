
ITEM.name = "Chinese stealth armor"
ITEM.description = "itemChineseStealthArmorDesc"
ITEM.model = "models/props_c17/SuitCase_Passenger_Physics.mdl"
ITEM.height = 2
ITEM.width = 2
-- ITEM.armorAmount = 120
ITEM.price = 540
ITEM.gasmask = false -- It will protect you from bad air
ITEM.resistance = false -- This will activate the protection bellow
ITEM.damage = { -- It is scaled; so 100 damage * 0.8 will makes the damage be 80.
			0.72, -- Bullets
			0.72, -- Slash
			0.72, -- Shock
			0.72, -- Burn
			1, -- Radiation
			1, -- Acid
			0.72, -- Explosion
}
ITEM.replacements = {
	{"player/neutral/hub/wastelander1", "ninja/chinese"},
	{"player/neutral/hub/wastelander2", "ninja/chinese"},
	{"player/neutral/hub/wastelander3", "ninja/chinese"},
	{"_male_", "_m_npc"},
	{"_female_", "_f_npc"},
	{"01", ""},
	{"04", ""},
	{"05", ""},
	{"07", ""},
	{"09", ""},
	{"ghoul", ""}
}

ITEM.maxDurability = 440

ITEM:Hook("Equip", function(item)
	local client = item.player
	local char = client:GetCharacter()
	local inv = char:GetInventory()
	local items = inv:GetItems()
	local stealthColor = Color( 255, 255, 255, 25 )
	
	client:SetColor(stealthColor)
	client:SetRenderMode( RENDERMODE_TRANSALPHA )
	client:DrawShadow(false)
	client:SetNoTarget(true)
	client:EmitSound("items/suitchargeok1.wav")
end)

ITEM:Hook("EquipUn", function(item)
	local client = item.player
	local char = client:GetCharacter()
	local inv = char:GetInventory()
	local items = inv:GetItems()
	local oldColor = Color( 255, 255, 255, 255 )
	
	client:SetColor(oldColor)
	client:SetRenderMode( RENDERMODE_TRANSALPHA )
	client:DrawShadow(true)
	client:SetNoTarget(false)
	client:EmitSound("items/suitchargeno1.wav")
end)