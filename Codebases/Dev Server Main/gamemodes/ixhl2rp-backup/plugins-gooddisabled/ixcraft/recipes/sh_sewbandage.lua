

RECIPE.name = "Sew Bandage"
RECIPE.description = "Sew a bandage from some loose cloth. Maybe not the most sterile."
RECIPE.model = "models/illusion/eftcontainers/bandage.mdl"
RECIPE.category = "Sewing"
RECIPE.bAttrInc = "gun"

RECIPE.requirements = {
    ["sewn_cloth"] = 3
}
RECIPE.results = {
	["bandage"] = 1
}
RECIPE.tools = {
	"sewing_kit"
}

RECIPE:PostHook("OnCanSee", function(client)
	char = client:GetCharacter()
	if (char:GetAttribute("guns", 0) < 3) then
		return false
	end
end)

RECIPE:PostHook("OnCanCraft", function(client)
	char = client:GetCharacter()
	if (char:GetAttribute("guns", 0) < 3) then
		return false, "You do not have sufficient skill to craft this!"
	end
end)
