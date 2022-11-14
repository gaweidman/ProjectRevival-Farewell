ITEM.name = "Deathclaw steak"
ITEM.model = "models/mosi/fallout4/props/food/steak.mdl"
ITEM.skin = 1
ITEM.description = "itemDeathclawSteakDesc"
ITEM.price = 130
ITEM.hunger = 100

ITEM:Hook("Eat", function(item)
	local client = item.player
	
	client:EmitSound("npc/barnacle/barnacle_gulp2.wav")
	
	for i = 1, 5 do
		timer.Simple(i, function()
			client:SetHealth(math.Clamp(client:Health() + 1, 0, client:GetMaxHealth()))
		end)
	end

	local stm = client:GetCharacter():GetAttribute("stm", 0)

	client:GetCharacter():SetAttrib("stm", math.max(0, stm + 1))

	timer.Simple(60, function()
		stm = client:GetCharacter():GetAttribute("stm", 0)

		client:GetCharacter():SetAttrib("stm", math.max(0, stm - 1))
	end)
end)