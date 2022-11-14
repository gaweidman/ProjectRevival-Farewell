
RECIPE.name = "Reload SMG Rounds"
RECIPE.description = "Reload SMG rounds with gunpowder."
RECIPE.model = "models/Items/BoxMRounds.mdl"
RECIPE.category = "Ammunition"
RECIPE.bAttrInc = "gun"

RECIPE.requirements = {
    ["emptysmg"] = 1,
    ["gunpowder"] = 5
}
RECIPE.results = {
	["smg1ammo"] = 1
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
