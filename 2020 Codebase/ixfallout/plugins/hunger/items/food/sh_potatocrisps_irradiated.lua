ITEM.name = "Irr. Potato Crisps"
ITEM.model = "models/mosi/fallout4/props/food/potatocrisps.mdl"
ITEM.description = "itemIrrPotatoCrispsDesc"
ITEM.price = 5
ITEM.hunger = 10
ITEM.thirst = -10
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