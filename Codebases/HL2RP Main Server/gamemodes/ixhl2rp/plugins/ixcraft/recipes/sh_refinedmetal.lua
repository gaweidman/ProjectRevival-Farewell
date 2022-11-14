
RECIPE.name = "Refined Metal"
RECIPE.description = "Melt down reclaimed metal and take the high quality material from it."
RECIPE.model = "models/props_c17/canisterchunk02a.mdl"
RECIPE.category = "Factory"

RECIPE.requirements = {
	["reclaimed_metal"] = 3
}
RECIPE.results = {
	["refined_metal"] = 1
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
