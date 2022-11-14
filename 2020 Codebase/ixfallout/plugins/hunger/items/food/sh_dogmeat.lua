ITEM.name = "Dog meat"
ITEM.model = "models/fallout 3/meat.mdl"
ITEM.description = "itemDogMeatDesc"
ITEM.price = 4
ITEM.hunger = 35
ITEM.radiation = 3

ITEM:Hook("Eat", function(item)
	local client = item.player
	
	client:EmitSound("npc/barnacle/barnacle_gulp2.wav")

	for i = 1, 8 do
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