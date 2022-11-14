
RECIPE.name = "Fusion core"
RECIPE.description = "recipeMicrofusionCellDesc"
RECIPE.category = "Ammunition"
RECIPE.model = "models/mosi/fallout4/props/fusion_core.mdl"
RECIPE.requirements = {
	["electronchargepack"] = 2
}
RECIPE.results = {
	["fusioncore"] = 1
}

RECIPE:PostHook("OnCanCraft", function(recipeTable, client)
	for _, v in pairs(ents.FindByClass("ix_station_weaponsworkbench")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, L("noWorkbench")
end)
