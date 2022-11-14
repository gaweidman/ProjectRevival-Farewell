ITEM.name = "Whiskey"
ITEM.description = "itemWhiskeyDesc"
ITEM.model = "models/mosi/fallout4/props/alcohol/whiskey.mdl"
ITEM.force = 10
ITEM.thirst = 25
ITEM.price = 10

ITEM:Hook("Drink", function(item)
	local client = item.player
	
	client:EmitSound("ui/drink.wav")
	client:GetCharacter():GiveMoney(1)
end)