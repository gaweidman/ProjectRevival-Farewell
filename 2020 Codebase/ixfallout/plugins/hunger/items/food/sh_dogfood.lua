ITEM.name = "Canned dog food"
ITEM.model = "models/mosi/fallout4/props/food/dogfood.mdl"
ITEM.description = "itemDogFoodDesc"
ITEM.price = 5
ITEM.hunger = 10
ITEM.radiation = 2
ITEM.empty = "tincan"

ITEM:Hook("Eat", function(item)
	local client = item.player
	
	client:EmitSound("npc/barnacle/barnacle_gulp2.wav")

	for i = 1, 5 do
		timer.Simple(i, function()
			client:SetHealth(math.Clamp(client:Health() + 1, 0, client:GetMaxHealth()))
		end)
	end
end)