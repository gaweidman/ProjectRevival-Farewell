ITEM.name = "Iguana-on-a-stick"
ITEM.model = "models/mosi/fallout4/props/food/iguanaonastick.mdl"
ITEM.description = "itemIguanaOnAStickDesc"
ITEM.price = 5
ITEM.hunger = 75
ITEM.radiation = 3

ITEM:Hook("Eat", function(item)
	local client = item.player
	
	client:EmitSound("npc/barnacle/barnacle_gulp2.wav")

	for i = 1, 12 do
		timer.Simple(i, function()
			client:SetHealth(math.Clamp(client:Health() + 1, 0, client:GetMaxHealth()))
		end)
	end
end)