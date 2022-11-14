ITEM.name = "Radscorpion steak"
ITEM.model = "models/mosi/fallout4/props/food/radscorpionsteak.mdl"
ITEM.description = "itemRadscorpionSteakDesc"
ITEM.price = 65
ITEM.hunger = 100

ITEM:Hook("Eat", function(item)
	local client = item.player
	
	client:EmitSound("npc/barnacle/barnacle_gulp2.wav")

	for i = 1, 10 do
		timer.Simple(i, function()
			client:SetHealth(math.Clamp(client:Health() + 1, 0, client:GetMaxHealth()))
		end)
	end
end)