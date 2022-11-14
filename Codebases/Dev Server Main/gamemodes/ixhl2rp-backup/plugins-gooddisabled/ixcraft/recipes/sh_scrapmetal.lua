
RECIPE.name = "Scrap Metal"
RECIPE.description = "Melt down charred metal and take the usable scrap from it."
RECIPE.model = "models/props_debris/metal_panelchunk02d.mdl"
RECIPE.category = "Factory"

RECIPE.requirements = {
	["burned_metal"] = 2
}
RECIPE.results = {
	["scrap_metal"] = 1
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
