
RECIPE.name = "Roasted mirelurk meat"
RECIPE.description = "recipeWaterDesc"
RECIPE.category = "Food"
RECIPE.model = "models/mosi/fallout4/props/food/mirelurkroast.mdl"
RECIPE.requirements = {
	["mirelurkmeat"] = 2
}
RECIPE.results = {
	["mirelurksteak"] = 1
}

RECIPE:PostHook("OnCanCraft", function(recipeTable, client)
	for _, v in pairs(ents.FindByClass("ix_station_cookingstation")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, L("noWorkbench")
end)
