ITEM.name = "Vim Captain's Blend"
ITEM.model = "models/mosi/fallout4/props/drink/vim.mdl"
ITEM.description = "itemVimCaptainDesc"
ITEM.skin = 2
ITEM.price = 50
ITEM.thirst = 30

ITEM:Hook("Eat", function(item)
	local client = item.player
	
	client:EmitSound("ui/drink.wav")
	client:RestoreStamina(20)
	client:GetCharacter():GiveMoney(1)

	for i = 1, 25 do
		timer.Simple(i, function()
			client:SetHealth(math.Clamp(client:Health() + 2, 0, client:GetMaxHealth()))
		end)
	end
end)