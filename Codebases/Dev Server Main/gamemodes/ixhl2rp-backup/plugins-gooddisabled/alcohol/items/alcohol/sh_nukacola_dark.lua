ITEM.name = "Nuka-Cola Dark"
ITEM.model = "models/mosi/fallout4/props/drink/nukacola.mdl"
ITEM.skin = 6
ITEM.description = "itemNukaColaDarkDesc"
ITEM.price = 50
ITEM.force = 35
ITEM.thirst = 10

ITEM:Hook("Drink", function(item)
	local client = item.player
	
	client:EmitSound("ui/drink.wav")
	client:GetCharacter():GiveMoney(1)
end)