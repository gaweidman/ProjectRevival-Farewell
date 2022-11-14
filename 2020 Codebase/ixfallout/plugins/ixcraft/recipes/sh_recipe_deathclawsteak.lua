
RECIPE.name = "Dealthclaw steak"
RECIPE.description = "recipeDeathclawSteak"
RECIPE.category = "Food"
RECIPE.model = "models/mosi/fallout4/props/food/deathclawmeat.mdl"
RECIPE.requirements = {
	["deathclawmeat"] = 1
}
RECIPE.results = {
	["deathclawsteak"] = 1
}

RECIPE:PostHook("OnCanCraft", function(recipeTable, client)
	for _, v in pairs(ents.FindByClass("ix_station_cookingstation")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, L("noWorkbench")
end)
