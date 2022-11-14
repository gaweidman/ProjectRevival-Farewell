
RECIPE.name = "Cram"
RECIPE.description = "recipeCramDesc"
RECIPE.category = "Food"
RECIPE.model = "models/mosi/fallout4/props/food/cram.mdl"
RECIPE.requirements = {
	["cram_irradiated"] = 2
}
RECIPE.results = {
	["cram"] = {["min"] = 1, ["max"] = 2}
}

RECIPE:PostHook("OnCanCraft", function(recipeTable, client)
	for _, v in pairs(ents.FindByClass("ix_station_chemistrystation")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, L("noWorkbench")
end)
