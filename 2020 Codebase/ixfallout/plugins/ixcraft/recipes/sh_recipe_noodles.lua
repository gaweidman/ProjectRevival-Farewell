
RECIPE.name = "Noodles"
RECIPE.description = "recipeNoodlesDesc"
RECIPE.category = "Food"
RECIPE.model = "models/mosi/fallout4/props/food/noodles.mdl"
RECIPE.requirements = {
	["razorgrain"] = 1,
	["dirtywater"] = 1
}
RECIPE.results = {
	["noodles"] = 1
}

RECIPE:PostHook("OnCanCraft", function(recipeTable, client)
	for _, v in pairs(ents.FindByClass("ix_station_cookingstation")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, L("noWorkbench")
end)
