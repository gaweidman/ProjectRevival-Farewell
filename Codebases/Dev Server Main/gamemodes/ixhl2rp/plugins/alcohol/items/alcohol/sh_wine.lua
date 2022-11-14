ITEM.name = "Wine"
ITEM.description = "itemWineDesc"
ITEM.model = "models/mosi/fallout4/props/alcohol/wine.mdl"
ITEM.force = 5
ITEM.thirst = 15
ITEM.price = 10

ITEM:Hook("Drink", function(item)
	local client = item.player
	
	client:EmitSound("ui/drink.wav")
	client:GetCharacter():GiveMoney(1)
end)