ITEM.name = "Vodka"
ITEM.description = "itemVodkaDesc"
ITEM.model = "models/mosi/fallout4/props/alcohol/vodka.mdl"
ITEM.force = 10
ITEM.thirst = 25
ITEM.price = 20

ITEM:Hook("Drink", function(item)
	local client = item.player
	
	client:EmitSound("ui/drink.wav")
	client:GetCharacter():GiveMoney(1)
end)