ITEM.name = "Nuka-Cola Victory"
ITEM.model = "models/mosi/fallout4/props/drink/nukacola2.mdl"
ITEM.skin = 2
ITEM.description = "itemNukaColaVictoryDesc"
ITEM.price = 75
ITEM.thirst = 40
ITEM.radiation = 10
ITEM.empty = "nukacola_bottle"

ITEM:Hook("Eat", function(item)
	local client = item.player
	
	client:EmitSound("ui/drink.wav")
	client:RestoreStamina(10)
	client:GetCharacter():GiveMoney(1)

	for i = 1, 20 do
		timer.Simple(i, function()
			client:SetHealth(math.Clamp(client:Health() + 3, 0, client:GetMaxHealth()))
		end)
	end

	local int = client:GetCharacter():GetAttribute("int", 0)

	client:GetCharacter():SetAttrib("int", math.max(0, int - 1))

	timer.Simple(120, function()
		int = client:GetCharacter():GetAttribute("int", 0)

		client:GetCharacter():SetAttrib("int", math.max(0, int + 1))
	end)
end)