
RECIPE.name = "Potato Crisps"
RECIPE.description = "recipePotatoCrispsDesc"
RECIPE.category = "Food"
RECIPE.model = "models/mosi/fallout4/props/food/potatocrisps.mdl"
RECIPE.requirements = {
	["potatocrisps_irradiated"] = 2
}
RECIPE.results = {
	["potatocrisps"] = {["min"] = 1, ["max"] = 2}
}

RECIPE:PostHook("OnCanCraft", function(recipeTable, client)
	for _, v in pairs(ents.FindByClass("ix_station_chemistrystation")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, L("noWorkbench")
end)
