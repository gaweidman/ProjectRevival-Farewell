
RECIPE.name = "Vim"
RECIPE.description = "recipeVimDesc"
RECIPE.category = "Food"
RECIPE.model = "models/mosi/fallout4/props/drink/vim.mdl"
RECIPE.requirements = {
	["corn"] = 1,
	["mutfruit"] = 1,
	["water"] = 1
}
RECIPE.results = {
	["vim"] = 1
}

RECIPE:PostHook("OnCanCraft", function(recipeTable, client)
	for _, v in pairs(ents.FindByClass("ix_station_cookingstation")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, L("noWorkbench")
end)
