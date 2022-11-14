
RECIPE.name = "Vim Quartz"
RECIPE.description = "recipeVimQuartzDesc"
RECIPE.category = "Food"
RECIPE.model = "models/mosi/fallout4/props/drink/vim.mdl"
RECIPE.skin = 1
RECIPE.requirements = {
	["vim"] = 1,
	["bubblegum"] = 1,
	["carrot"] = 1
}
RECIPE.results = {
	["vim_quartz"] = 1
}

RECIPE:PostHook("OnCanCraft", function(recipeTable, client)
	for _, v in pairs(ents.FindByClass("ix_station_cookingstation")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, L("noWorkbench")
end)
