
RECIPE.name = "Wine"
RECIPE.description = "recipeWineDesc"
RECIPE.category = "Alcohol"
RECIPE.model = "models/mosi/fallout4/props/alcohol/wine.mdl"
RECIPE.requirements = {
	["mutfruit"] = 2,
	["dirtywater"] = 1,
}
RECIPE.results = {
	["wine"] = 1
}

RECIPE:PostHook("OnCanCraft", function(recipeTable, client)
	for _, v in pairs(ents.FindByClass("ix_station_foodstation")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, L("noWorkbench")
end)
