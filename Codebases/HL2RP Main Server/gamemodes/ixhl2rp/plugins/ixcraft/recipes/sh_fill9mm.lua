
RECIPE.name = "Reload 9mm Rounds"
RECIPE.description = "Reload 9mm rounds with gunpowder."
RECIPE.model = "models/Items/BoxSRounds.mdl"
RECIPE.category = "Ammunition"
RECIPE.bAttrInc = "gun"

RECIPE.requirements = {
    ["empty9mm"] = 1,
    ["gunpowder"] = 4
}
RECIPE.results = {
	["pistolammo"] = 1
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
