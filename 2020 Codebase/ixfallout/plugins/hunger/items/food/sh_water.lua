ITEM.name = "Purified water"
ITEM.model = "models/mosi/fallout4/props/drink/water.mdl"
ITEM.description = "itemWaterDesc"
ITEM.price = 20
ITEM.thirst = 50

ITEM:Hook("Eat", function(item)
	local client = item.player
	
	client:EmitSound("npc/barnacle/barnacle_gulp2.wav")

	for i = 1, 5 do
		timer.Simple(i, function()
			client:SetHealth(math.Clamp(client:Health() + 2, 0, client:GetMaxHealth()))
		end)
	end
end)