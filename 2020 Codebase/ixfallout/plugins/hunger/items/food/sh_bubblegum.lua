ITEM.name = "Bubblegum"
ITEM.model = "models/mosi/fallout4/props/food/bubblegum.mdl"
ITEM.description = "itemBubblegumDesc"
ITEM.price = 1
ITEM.radiation = 1

ITEM:Hook("Eat", function(item)
	local client = item.player
	
	client:EmitSound("npc/barnacle/barnacle_gulp2.wav")
	client:SetHealth(math.min(client:Health() + 1, client:GetMaxHealth()))
end)