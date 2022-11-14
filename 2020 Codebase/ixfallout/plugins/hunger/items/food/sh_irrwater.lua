ITEM.name = "Irradiated water"
ITEM.model = "models/mosi/fallout4/props/drink/dirtywater.mdl"
ITEM.description = "itemIrrWaterDesc"
ITEM.price = 5
ITEM.thirst = 50
ITEM.radiation = 16

ITEM:Hook("Eat", function(item)
	local client = item.player
	
	client:EmitSound("npc/barnacle/barnacle_gulp2.wav")

	for i = 1, 5 do
		timer.Simple(i, function()
			client:SetHealth(math.Clamp(client:Health() + 2, 0, client:GetMaxHealth()))
		end)
	end
end)