ITEM.name = "Blood pack"
ITEM.model = "models/mosi/fallout4/props/aid/bloodbag.mdl"
ITEM.description = "itemBloodPackDesc"
ITEM.price = 5
ITEM.category = "misc"

ITEM:Hook("Eat", function(item)
	local client = item.player
	
	client:EmitSound("npc/barnacle/barnacle_gulp2.wav")
	client:SetHealth(math.min(client:Health() + 1, client:GetMaxHealth()))
end)