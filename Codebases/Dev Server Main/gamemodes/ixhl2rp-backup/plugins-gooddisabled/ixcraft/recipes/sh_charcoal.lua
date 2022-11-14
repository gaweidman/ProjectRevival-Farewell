
RECIPE.name = "Charcoal"
RECIPE.description = "Take good, quality wood, and burn it to make a more useful substance."
RECIPE.model = "models/illusion/eftcontainers/militarycable.mdl"
RECIPE.category = "Factory"
RECIPE.requirements = {
	["plank"] = 2
}
RECIPE.results = {
	["charcoal"] = 1
}

RECIPE:PostHook("OnCanSee", function(client)
	char = client:GetCharacter()
	if (char:GetAttribute("guns", 0) < 0) then
		return false
	end
end)


RECIPE:PostHook("OnCanCraft", function(client)
	for _, v in pairs(ents.FindByClass("ix_station_forge")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, "You need to be near a forge."
end)
