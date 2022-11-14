ITEM.name = "Human steak"
ITEM.model = "models/mosi/fallout4/props/food/humanmeat.mdl"
ITEM.description = "itemHumanSteakDesc"
ITEM.price = 0
ITEM.hunger = 60
ITEM.radiation = 3

ITEM:Hook("Eat", function(item)
	local client = item.player
	
	client:EmitSound("npc/barnacle/barnacle_gulp2.wav")
	
	for i = 1, 10 do
		timer.Simple(i, function()
			client:SetHealth(math.Clamp(client:Health() + 1, 0, client:GetMaxHealth()))
		end)
	end
end)