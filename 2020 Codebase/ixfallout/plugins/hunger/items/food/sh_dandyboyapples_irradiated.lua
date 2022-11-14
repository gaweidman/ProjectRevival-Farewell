ITEM.name = "Irr. Dandy Boy Apples"
ITEM.model = "models/mosi/fallout4/props/food/dandyboyapples.mdl"
ITEM.description = "itemIrrDandyBoyApplesDesc"
ITEM.price = 5
ITEM.hunger = 15
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