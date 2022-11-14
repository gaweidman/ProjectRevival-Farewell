ITEM.name = "Mole rat meat"
ITEM.model = "models/mosi/fallout4/props/food/moleratmeat.mdl"
ITEM.description = "itemMoleRatMeatDesc"
ITEM.price = 4
ITEM.hunger = 25
ITEM.radiation = 3

ITEM:Hook("Eat", function(item)
	local client = item.player
	
	client:EmitSound("npc/barnacle/barnacle_gulp2.wav")

	for i = 1, 5 do
		timer.Simple(i, function()
			client:SetHealth(math.Clamp(client:Health() + 1, 0, client:GetMaxHealth()))
		end)
	end

	local str = client:GetCharacter():GetAttribute("str", 0)

	client:GetCharacter():SetAttrib("str", math.max(0, str - 1))

	timer.Simple(120, function()
		str = client:GetCharacter():GetAttribute("str", 0)

		client:GetCharacter():SetAttrib("str", math.max(0, str + 1))
	end)
end)