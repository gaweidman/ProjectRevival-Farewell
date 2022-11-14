
RECIPE.name = "Caravan lunch"
RECIPE.description = "recipeCaravanLunchDesc"
RECIPE.model = "models/mosi/fallout4/props/food/cram.mdl"
RECIPE.category = "Food"
RECIPE.requirements = {
	["cram"] = 1,
	["instamash"] = 1,
	["lunchbox"] = 1,
	["porkbeans"] = 1,
}
RECIPE.results = {
	["caravanlunch"] = 1,
}

RECIPE:PostHook("OnCanCraft", function(recipeTable, client)
	for _, v in pairs(ents.FindByClass("ix_station_cookingstation")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, L("noWorkbench")
end)
