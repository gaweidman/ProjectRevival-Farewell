ITEM.name = "Caravan lunch"
ITEM.model = "models/mosi/fallout4/props/junk/lunchbox.mdl"
ITEM.description = "itemCaravanLunchDesc"
ITEM.price = 5
ITEM.hunger = 100
ITEM.thirst = 15

ITEM:Hook("Eat", function(item)
	local client = item.player
	
	client:EmitSound("npc/barnacle/barnacle_gulp2.wav")

	for i = 1, 15 do
		timer.Simple(i, function()
			client:SetHealth(math.Clamp(client:Health() + 3, 0, client:GetMaxHealth()))
		end)
	end
end)