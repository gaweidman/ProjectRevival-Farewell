ITEM.name = "Nuka-Cherry"
ITEM.model = "models/mosi/fallout4/props/drink/nukacola.mdl"
ITEM.skin = 2
ITEM.description = "itemNukaCherryDesc"
ITEM.price = 40
ITEM.thirst = 15
ITEM.radiation = 3
ITEM.empty = "nukacola_bottle"

ITEM:Hook("Eat", function(item)
	local client = item.player
	
	client:EmitSound("ui/drink.wav")
	client:RestoreStamina(15)
	client:GetCharacter():GiveMoney(1)

	for i = 1, 25 do
		timer.Simple(i, function()
			client:SetHealth(math.Clamp(client:Health() + 2, 0, client:GetMaxHealth()))
		end)
	end
end)