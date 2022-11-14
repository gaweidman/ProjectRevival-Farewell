ITEM.name = "Deathclaw egg omelette"
ITEM.model = "models/mosi/fallout4/props/food/deathclawomelette.mdl"
ITEM.description = "itemDeathclawOmelette"
ITEM.price = 100
ITEM.hunger = 100

ITEM:Hook("Eat", function(item)
	local client = item.player
	
	client:EmitSound("npc/barnacle/barnacle_gulp2.wav")

	for i = 1, 120 do
		timer.Simple(i, function()
			client:SetHealth(math.Clamp(client:Health() + 1, 0, client:GetMaxHealth()))
		end)
	end
end)