
RECIPE.name = "Salvage Electronic Parts"
RECIPE.description = "Take the useful bits out of scrap electronics."
RECIPE.model = "models/props_lab/reciever01c.mdl"
RECIPE.category = "Electronics"

RECIPE.requirements = {
    ["scrap_electronics"] = 3
}

RECIPE.results = {
	["refined_electronics"] = 1
}

if (SERVER) then
    RECIPE:PostHook("OnCraft", function(client)
        local character = client:GetCharacter()
        character:UpdateAttrib("eng", 0.025)
    end)
end