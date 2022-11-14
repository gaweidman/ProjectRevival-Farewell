
ITEM.name = "UU Gin"
ITEM.description = "A glass bottle with the UU logo on it. It reads: 2% gin. Inside, is gin."
ITEM.model = Model("models/bioshockinfinite/jin_bottle.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Consumables"
ITEM.permit = "consumables"

ITEM.functions.Drink = {
	OnRun = function(itemTable)
		local client = itemTable.player

		client:SetHealth(math.min(client:Health() + 10, client:GetMaxHealth()))

		return true
	end,
}
