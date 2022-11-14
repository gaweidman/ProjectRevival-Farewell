
RECIPE.name = "Package Handcannon Packing"
RECIPE.description = "Pack scrap metal and gunpowder into a paper pouch."
RECIPE.model = "models/props_lab/box01a.mdl"
RECIPE.category = "Gunsmithing"
RECIPE.bAttrInc = "eng"

RECIPE.requirements = {
    ["gunpowder"] = 1,
    ["paper"] = 1,
    ["scrap_metal"] = 1
}
RECIPE.results = {
	["handmadeshell"] = 2
}

RECIPE:PostHook("OnCanSee", function(client)
	char = client:GetCharacter()
	if (char:GetAttribute("eng", 0) < 10) then
		return false
	end
end)

RECIPE:PostHook("OnCanCraft", function(client)
	char = client:GetCharacter()
	if (char:GetAttribute("eng", 0) < 10) then
		return false, "You do not have sufficient skill to craft this!"
	end
end)
