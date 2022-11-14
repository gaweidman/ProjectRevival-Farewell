ITEM.name = "Chinese food"
ITEM.model = "models/props_junk/garbage_takeoutcarton001a.mdl"
ITEM.description = "itemChineseFoodDesc"
ITEM.price = 5
ITEM.hunger = 25
ITEM.radiation = 3

ITEM:Hook("Eat", function(item)
	local client = item.player
	
	client:EmitSound("npc/barnacle/barnacle_gulp2.wav")

	for i = 1, 5 do
		timer.Simple(i, function()
			client:SetHealth(math.Clamp(client:Health() + 1, 0, client:GetMaxHealth()))
		end)
	end
end)