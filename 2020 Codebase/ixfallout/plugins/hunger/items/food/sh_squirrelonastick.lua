ITEM.name = "Squirrel on a stick"
ITEM.model = "models/mosi/fallout4/props/food/squirrelonastick.mdl"
ITEM.description = "itemSquirrelOnAStickDesc"
ITEM.price = 5
ITEM.hunger = 75
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