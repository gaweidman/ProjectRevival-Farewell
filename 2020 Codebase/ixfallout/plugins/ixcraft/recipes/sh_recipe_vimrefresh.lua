
RECIPE.name = "Vim Refresh"
RECIPE.description = "recipeVimRefreshDesc"
RECIPE.category = "Food"
RECIPE.model = "models/mosi/fallout4/props/drink/vim.mdl"
RECIPE.skin = 3
RECIPE.requirements = {
	["vim"] = 1,
	["dandyboyapples"] = 1,
	["gourd"] = 1
}
RECIPE.results = {
	["vim_refresh"] = 1
}

RECIPE:PostHook("OnCanCraft", function(recipeTable, client)
	for _, v in pairs(ents.FindByClass("ix_station_cookingstation")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, L("noWorkbench")
end)
