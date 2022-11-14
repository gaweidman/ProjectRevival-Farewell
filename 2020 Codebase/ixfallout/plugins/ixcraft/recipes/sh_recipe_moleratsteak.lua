
RECIPE.name = "Molerat steak"
RECIPE.description = "Cook a Molerat steak."
RECIPE.category = "Food"
RECIPE.model = "models/mosi/fallout4/props/food/moleratsteak.mdl"
RECIPE.requirements = {
	["moleratmeat"] = 1
}
RECIPE.results = {
	["moleratsteak"] = 1
}

RECIPE:PostHook("OnCanCraft", function(recipeTable, client)
	for _, v in pairs(ents.FindByClass("ix_station_cookingstation")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, L("noWorkbench")
end)
