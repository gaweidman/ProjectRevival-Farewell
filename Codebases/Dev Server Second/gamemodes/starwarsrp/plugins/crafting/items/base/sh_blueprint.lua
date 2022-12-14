ITEM.name = "Blueprint"
ITEM.model = "models/lt_c/sci_fi/computers/crystal_hdd.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.price = 0
ITEM.category = "Blueprints"
ITEM.recipe = { ["paper"] = 1, ["ink"] = 1, ["plastic"] = 2}
ITEM.isBlueprint = TRUE
ITEM.crafts = "bipod"
ITEM.functions.Use = {
	name = "Save",
	tip = "equipTip",
	icon = "icon16/disk.png",
	onRun = function(item)
		local itemsCanCraft = item.player:getChar():getData("craftableItems", {})
		table.insert(itemsCanCraft, item.crafts)
		item.player:getChar():setData("craftableItems", itemsCanCraft)
	end,
	onCanRun = function(item)
		local itemCanCraft = item.player:getChar():getData("craftableItems", {})
		return !table.HasValue(itemCanCraft, item.crafts)
	end
}
