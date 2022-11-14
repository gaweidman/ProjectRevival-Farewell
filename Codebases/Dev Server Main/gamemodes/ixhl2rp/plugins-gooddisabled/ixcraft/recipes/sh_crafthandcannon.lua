
RECIPE.name = "Craft Handcannon"
RECIPE.description = "Craft the lowest tier of makeshift gun."
RECIPE.model = "models/weapons/yurie_rustalpha/wm-handcannon.mdl"
RECIPE.category = "Gunsmithing"
RECIPE.bAttrInc = "eng"

RECIPE.requirements = {
    ["reclaimed_metal"] = 1,
    ["wood_piece"] = 1,
    ["ducttape"] = 1
}

RECIPE.results = {
	["handcannon"] = 1
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
