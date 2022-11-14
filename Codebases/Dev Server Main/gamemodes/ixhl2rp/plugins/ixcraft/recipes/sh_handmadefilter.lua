
RECIPE.name = "Handmade Filter"
RECIPE.description = "Homemake a short-term gas mask filter."
RECIPE.model = "mmodels/props_lunk/popcan01a.mdl"
RECIPE.category = "Factory"
RECIPE.requirements = {
	["charcoal"] = 1,
	["insulatingtape"] = 1,
	["emptywatercan"] = 1
}
RECIPE.results = {
	["handmadefilter"] = 1
}
RECIPE.tools = {
	"pliers"
}

RECIPE:PostHook("OnCanSee", function(client)
	char = client:GetCharacter()
	if (char:GetAttribute("guns", 0) < 4) then
		return false
	end
end)
