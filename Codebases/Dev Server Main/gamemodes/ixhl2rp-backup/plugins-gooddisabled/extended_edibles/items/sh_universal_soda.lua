
ITEM.name = "Universal Soda"
ITEM.model = Model("models/props_junk/garbage_plasticbottle003a.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.description = "A 2 Litre plastic bottle filled with a substance mimicking the taste of Diet Coke."
ITEM.category = "Consumables"
ITEM.permit = "consumables"

ITEM.functions.Drink = {
	OnRun = function(itemTable)
		local client = itemTable.player

		client:SetHealth(math.min(client:Health() + 10, client:GetMaxHealth()))

		return true
	end,
}
