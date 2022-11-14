ITEM.name = "Radroach meat"
ITEM.model = "models/mosi/fallout4/props/food/radroachmeat.mdl"
ITEM.description = "itemRadroachMeatDesc"
ITEM.price = 2
ITEM.hunger = 25
ITEM.radiation = 10

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