ITEM.name = "Mirelurk egg omelette"
ITEM.model = "models/mosi/fallout4/props/food/mirelurkomelette.mdl"
ITEM.description = "itemMirelurkOmeletteDesc"
ITEM.price = 30
ITEM.hunger = 45

ITEM:Hook("Eat", function(item)
	local client = item.player
	
	client:EmitSound("npc/barnacle/barnacle_gulp2.wav")
	client:RestoreStamina(50)

	for i = 1, 10 do
		timer.Simple(i, function()
			client:SetHealth(math.Clamp(client:Health() + 2, 0, client:GetMaxHealth()))
		end)
	end
end)