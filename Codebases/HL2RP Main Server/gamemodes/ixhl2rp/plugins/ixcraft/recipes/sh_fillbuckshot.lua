
RECIPE.name = "Reload Shotgun Shells"
RECIPE.description = "Reload shotgun shells with gunpowder."
RECIPE.model = "models/Items/BoxBuckshot.mdl"
RECIPE.category = "Ammunition"
RECIPE.bAttrInc = "gun"

RECIPE.requirements = {
    ["emptybuckshot"] = 1,
    ["gunpowder"] = 2
}
RECIPE.results = {
	["shotgunammo"] = 1
}
RECIPE.tools = {}

RECIPE:PostHook("OnCanCraft", function(client)
	for _, v in pairs(ents.FindByClass("ix_station_reloadingtable")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, "You need to be near a reloading table."
end)
