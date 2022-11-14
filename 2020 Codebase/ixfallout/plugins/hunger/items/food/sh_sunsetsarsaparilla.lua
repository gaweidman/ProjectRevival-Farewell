ITEM.name = "Sunset Sarsaparilla"
ITEM.model = "models/mosi/fallout4/props/drink/sunsetsarsaparilla.mdl"
ITEM.description = "itemSunsetSarsaparillaDesc"
ITEM.price = 3
ITEM.thirst = 10
ITEM.empty = "sunsetsarsaparilla_bottle"

ITEM:Hook("Eat", function(item)
	local client = item.player
	
	client:EmitSound("ui/drink.wav")
	client:RestoreStamina(10)

	for i = 1, 25 do
		timer.Simple(i, function()
			client:SetHealth(math.Clamp(client:Health() + 2, 0, client:GetMaxHealth()))
		end)
	end

	local per = math.random(0, 100)

	if client:GetChar():GetAttribute("rck", 0) then
		local per = math.random(0, 100) + client:GetChar():GetAttribute("rck", 0) * ix.config.Get("luckMultiplier", 1)
	end

	if per > 95 then
		client:GetInventory():Add("bottlecap_star", 1)
	else
		client:GetCharacter():GiveMoney(1)
	end
end)