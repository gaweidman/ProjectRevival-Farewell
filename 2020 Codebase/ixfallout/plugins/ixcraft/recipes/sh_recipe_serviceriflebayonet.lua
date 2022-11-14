
RECIPE.name = "Service rifle (bayonet)"
RECIPE.description = "recipeServiceRifleBayonetDesc"
RECIPE.category = "Weapons"
RECIPE.model = "models/halokiller38/fallout/weapons/assaultrifles/battleriflebayo.mdl"
RECIPE.requirements = {
	["servicerifle"] = 1,
	["combatknife"] = 1
}
RECIPE.results = {
	["servicerifle_bayonet"] = 1
}

RECIPE:PostHook("OnCanCraft", function(recipeTable, client)
	for _, v in pairs(ents.FindByClass("ix_station_weaponsworkbench")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, L("noWorkbench")
end)
