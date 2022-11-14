ITEM.name = "Dog steak"
ITEM.model = "models/mosi/fallout4/props/food/dogmeat.mdl"
ITEM.description = "itemDogSteakDesc"
ITEM.price = 4
ITEM.hunger = 35
ITEM.radiation = 3

ITEM:Hook("Eat", function(item)
	local client = item.player
	
	client:EmitSound("npc/barnacle/barnacle_gulp2.wav")

	for i = 1, 10 do
		timer.Simple(i, function()
			client:SetHealth(math.Clamp(client:Health() + 2, 0, client:GetMaxHealth()))
		end)
	end
end)