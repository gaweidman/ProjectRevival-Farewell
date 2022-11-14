
RECIPE.name = "Reclaimed Metal"
RECIPE.description = "Melt down scrap metal and take the decent quality material from it."
RECIPE.model = "models/props_c17/oildrumchunk01d.mdl"
RECIPE.category = "Factory"
RECIPE.bAttrInc = "gun"
RECIPE.requirements = {
	["scrap_metal"] = 3
}
RECIPE.results = {
	["reclaimed_metal"] = 1
}
RECIPE.tools = {
	"blacksmithtongs"
}

RECIPE:PostHook("OnCanCraft", function(client)
	for _, v in pairs(ents.FindByClass("ix_station_forge")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, "You need to be near a forge."
end)
