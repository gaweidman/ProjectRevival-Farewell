ITEM.name = "Irr. Sugar Bombs"
ITEM.model = "models/mosi/fallout4/props/food/sugarbombs.mdl"
ITEM.description = "itemIrrSugarBombsDesc"
ITEM.price = 3
ITEM.hunger = 30
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