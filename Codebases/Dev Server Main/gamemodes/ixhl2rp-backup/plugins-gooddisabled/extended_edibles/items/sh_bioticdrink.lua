
ITEM.name = "Bleach"
ITEM.model = Model("models/props_junk/garbage_plasticbottle001a.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.description = "A plastic container containing bleach inside."
ITEM.category = "Consumables"
ITEM.permit = "consumables"

ITEM.functions.Drink = {
	OnRun = function(itemTable)
		local client = itemTable.player

		client:Kill()

		return true
	end,
}
