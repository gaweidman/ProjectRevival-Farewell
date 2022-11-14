ITEM.name = "Radscorpion meat"
ITEM.model = "models/mosi/fallout4/props/food/radscorpionmeat.mdl"
ITEM.description = "itemRadscorpionMeatDesc"
ITEM.price = 55
ITEM.hunger = 75
ITEM.radiation = 13

ITEM:Hook("Eat", function(item)
	local client = item.player
	
	client:EmitSound("npc/barnacle/barnacle_gulp2.wav")
	
	for i = 1, 5 do
		timer.Simple(i, function()
			client:SetHealth(math.Clamp(client:Health() + 1, 0, client:GetMaxHealth()))
		end)
	end	
end)