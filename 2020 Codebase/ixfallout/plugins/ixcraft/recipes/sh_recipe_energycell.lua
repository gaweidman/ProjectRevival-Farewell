
RECIPE.name = "Energy cell"
RECIPE.description = "recipeEnergyCellDesc"
RECIPE.category = "Ammunition"
RECIPE.model = "models/maxibammo/energycell.mdl"
RECIPE.requirements = {
	["microfusioncell"] = 1
}
RECIPE.results = {
	["energycell"] = 1
}

RECIPE:PostHook("OnCanCraft", function(recipeTable, client)
	for _, v in pairs(ents.FindByClass("ix_station_weaponsworkbench")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, L("noWorkbench")
end)
