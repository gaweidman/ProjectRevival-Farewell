ITEM.name = "Nuka-Grape"
ITEM.model = "models/mosi/fallout4/props/drink/nukacola.mdl"
ITEM.skin = 3
ITEM.description = "itemNukaGrapeDesc"
ITEM.price = 20
ITEM.thirst = 100
ITEM.radiation = -100
ITEM.empty = "nukacola_bottle"

ITEM:Hook("Eat", function(item)
	local client = item.player
	
	client:EmitSound("ui/drink.wav")
	client:RestoreStamina(50)
	client:GetCharacter():GiveMoney(1)

	for i = 1, 20 do
		timer.Simple(i, function()
			client:SetHealth(math.Clamp(client:Health() + 2, 0, client:GetMaxHealth()))
		end)
	end
end)