
RECIPE.name = "Sew Fingerless Gloves"
RECIPE.description = "Sew a pair of fingerless gloves. Pretty good look."
RECIPE.model = "models/tnb/items/gloves.mdl"
RECIPE.category = "Sewing"
RECIPE.bAttrInc = "gun"

RECIPE.requirements = {
    ["sewn_cloth"] = 4
}
RECIPE.results = {
	["fingerlessgloves"] = 1
}
RECIPE.tools = {
	"sewing_kit"
}

RECIPE:PostHook("OnCanSee", function(client)
	char = client:GetCharacter()
	if (char:GetAttribute("gun", 0) < 4) then
		return false
	end
end)

RECIPE:PostHook("OnCanCraft", function(client)
	char = client:GetCharacter()
	if (char:GetAttribute("gun", 0) < 4) then
		return false, "You do not have sufficient skill to craft this!"
	end
end)
