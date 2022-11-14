ITEM.name = "Deathclaw meat"
ITEM.model = "models/mosi/fallout4/props/food/deathclawmeat.mdl"
ITEM.description = "itemDeathclawMeatDesc"
ITEM.price = 110
ITEM.hunger = 90
ITEM.radiation = 6

ITEM:Hook("Eat", function(item)
	local client = item.player
	
	client:EmitSound("npc/barnacle/barnacle_gulp2.wav")
	
	for i = 1, 5 do
		timer.Simple(i, function()
			client:SetHealth(math.Clamp(client:Health() + 1, 0, client:GetMaxHealth()))
		end)
	end
end)