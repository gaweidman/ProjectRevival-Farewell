ITEM.name = "Nuka-Cola Quartz"
ITEM.model = "models/mosi/fallout4/props/drink/nukacola.mdl"
ITEM.skin = 5
ITEM.description = "itemNukaColaQuartzDesc"
ITEM.price = 40
ITEM.thirst = 30
ITEM.radiation = 10
ITEM.empty = "nukacola_bottle"

ITEM:Hook("Eat", function(item)
	local client = item.player
	
	client:EmitSound("ui/drink.wav")
	client:RestoreStamina(20)
	client:GetCharacter():GiveMoney(1)

	for i = 1, 20 do
		timer.Simple(i, function()
			client:SetHealth(math.Clamp(client:Health() + 3, 0, client:GetMaxHealth()))
		end)
	end
end)