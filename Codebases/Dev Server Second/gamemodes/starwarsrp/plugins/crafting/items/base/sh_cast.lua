ITEM.name = "Cast"
ITEM.model = "models/maxofs2d/hover_plate.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.price = 0
ITEM.category = "Casts"
ITEM.recipe = { ["paper"] = 1, ["ink"] = 1, ["plastic"] = 2}
ITEM.isBlueprint = TRUE
ITEM.crafts = "bipod"
ITEM.functions.Use = {
	name = "Save",
	tip = "equipTip",
	icon = "icon16/disk.png",
	onRun = function(item)
		local itemsCanCraft = item.player:getChar():getData("castableItems", {})
		table.insert(itemsCanCraft, item.crafts)
		item.player:getChar():setData("castableItems", itemsCanCraft)
	end,
	onCanRun = function(item)
		local itemCanCraft = item.player:getChar():getData("castableItems", {})
		return !table.HasValue(itemCanCraft, item.crafts)
	end
}
