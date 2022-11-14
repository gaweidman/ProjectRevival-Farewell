ITEM.name = "Bourbon"
ITEM.description = "itemBourbonDesc"
ITEM.model = "models/mosi/fallout4/props/alcohol/bourbon.mdl"
ITEM.force = 10
ITEM.thirst = 25
ITEM.price = 7

ITEM:Hook("Drink", function(item)
	local client = item.player
	
	client:EmitSound("ui/drink.wav")
	client:GetCharacter():GiveMoney(1)
end)