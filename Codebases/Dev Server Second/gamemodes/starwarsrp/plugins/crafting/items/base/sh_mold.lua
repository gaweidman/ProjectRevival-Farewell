ITEM.name = "Mold"
//ITEM.desc = "A hard drive with instructions on it."
ITEM.model = "models/lt_c/sci_fi/computers/crystal_hdd.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.price = 0
ITEM.category = "Molds"
ITEM.recipe = { ["paper"] = 1, ["ink"] = 1, ["plastic"] = 2}
ITEM.isBlueprint = TRUE
ITEM.crafts = "bipod"
ITEM.functions.Use = {
	name = "Save",
	tip = "equipTip",
	icon = "icon16/disk.png",
	onRun = function(item)
		local itemsCanMold = item.player:getChar():getData("moldableItems", {})
		table.insert(itemsCanMold, "tkhelmetshell")
		table.insert(itemsCanMold, "tkhelmetgear")
		table.insert(itemsCanMold, "tkrightfoot")
		table.insert(itemsCanMold, "tkbelt")
		table.insert(itemsCanMold, "tkleftelbow")
		table.insert(itemsCanMold, "tkrightelbow")
		table.insert(itemsCanMold, "tkleftleg")
		table.insert(itemsCanMold, "tkleftfoot")
		table.insert(itemsCanMold, "tkleftknee")
		table.insert(itemsCanMold, "tkleftkneecap")
		table.insert(itemsCanMold, "tkleftpauldron")
		table.insert(itemsCanMold, "tkleftwrist")
		table.insert(itemsCanMold, "tkrightkneecap")
		table.insert(itemsCanMold, "tkrightarm")
		table.insert(itemsCanMold, "tkrightknee")
		table.insert(itemsCanMold, "tkrightpauldron")
		table.insert(itemsCanMold, "tkshell")
		table.insert(itemsCanMold, "tkrightwrist")
		table.insert(itemsCanMold, "tkupperbelt")
		item.player:getChar():setData("moldableItems", itemsCanMold)
	end,
	onCanRun = function(item)
		local itemCanMold = item.player:getChar():getData("moldableItems", {})
		return !table.HasValue(itemCanMold, item.molds)
	end
}
