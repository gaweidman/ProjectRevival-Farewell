ITEM.name = "Brahmin milk"
ITEM.model = "models/props_junk/garbage_milkcarton001a.mdl"
ITEM.description = "itemBrahminMilkDesc"
ITEM.price = 20
ITEM.thirst = 10
ITEM.radiation = -25

ITEM:Hook("Eat", function(item)
	local client = item.player

	client:EmitSound("npc/barnacle/barnacle_gulp2.wav")
	client:RestoreStamina(10)

	for i = 1, 5 do
		timer.Simple(i, function()
			client:SetHealth(math.Clamp(client:Health() + 1, 0, client:GetMaxHealth()))
		end)
	end
end)