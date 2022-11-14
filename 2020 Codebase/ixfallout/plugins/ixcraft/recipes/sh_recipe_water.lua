
RECIPE.name = "Water"
RECIPE.description = "recipeWaterDesc"
RECIPE.category = "Food"
RECIPE.model = "models/mosi/fallout4/props/drink/water.mdl"
RECIPE.requirements = {
	["dirtywater"] = 3
}
RECIPE.results = {
	["water"] = {["min"] = 1, ["max"] = 3}
}

RECIPE:PostHook("OnCanCraft", function(recipeTable, client)
	for _, v in pairs(ents.FindByClass("ix_station_cookingstation")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, L("noWorkbench")
end)
