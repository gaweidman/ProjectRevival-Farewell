ITEM.name = "Irradiated InstaMash"
ITEM.model = "models/mosi/fallout4/props/food/instamash.mdl"
ITEM.description = "itemIrrInstaMashDesc"
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
end)