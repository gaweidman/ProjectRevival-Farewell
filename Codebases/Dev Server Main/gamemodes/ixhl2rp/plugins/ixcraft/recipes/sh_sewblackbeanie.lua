
RECIPE.name = "Sew Black Beanie"
RECIPE.description = "Sew a raggedy black beanie."
RECIPE.model = "models/tnb/items/beanie.mdl"
RECIPE.category = "Sewing"
RECIPE.bAttrInc = "gun"

RECIPE.requirements = {
    ["sewn_cloth"] = 6
}
RECIPE.results = {
	["blackbeanie"] = 1
}
RECIPE.tools = {
	"sewing_kit"
}

RECIPE:PostHook("OnCanSee", function(client)
	char = client:GetCharacter()
	if (char:GetAttribute("gun", 0) < 5) then
		return false
	end
end)

RECIPE:PostHook("OnCanCraft", function(client)
	char = client:GetCharacter()
	if (char:GetAttribute("gun", 0) < 5) then
		return false, "You do not have sufficient skill to craft this!"
	end
end)
