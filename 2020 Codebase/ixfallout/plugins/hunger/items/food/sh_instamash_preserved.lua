ITEM.name = "Preserved InstaMash"
ITEM.model = "models/mosi/fallout4/props/food/instamash.mdl"
ITEM.skin = 1
ITEM.description = "itemPrsvInstaMashDesc"
ITEM.price = 3
ITEM.hunger = 37

ITEM:Hook("Eat", function(item)
	local client = item.player
	
	client:EmitSound("npc/barnacle/barnacle_gulp2.wav")

	for i = 1, 5 do
		timer.Simple(i, function()
			client:SetHealth(math.Clamp(client:Health() + 1, 0, client:GetMaxHealth()))
		end)
	end
end)