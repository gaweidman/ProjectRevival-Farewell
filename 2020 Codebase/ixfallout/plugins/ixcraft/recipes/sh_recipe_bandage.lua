
RECIPE.name = "Bandage"
RECIPE.description = "recipeBandageDesc"
RECIPE.category = "Medical"
RECIPE.model = "models/props_lab/box01a.mdl"
RECIPE.requirements = {
	["money"] = 2
}
RECIPE.results = {
	["bandage"] = 1
}

RECIPE:PostHook("OnCanCraft", function(recipeTable, client)
	for _, v in pairs(ents.FindByClass("ix_station_chemistrystation")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, L("noWorkbench")
end)
