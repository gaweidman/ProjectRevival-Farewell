CLASS.name = "Strider"
CLASS.faction = FACTION_OSA
CLASS.isDefault = false

function CLASS:OnSet(client)
	local character = client:GetCharacter()

	if (character) then
		character:SetName("OSA.C17-STR." .. Schema:ZeroNumber(math.random(1, 99999), 5), true)
		character:SetModel("models/combine_strider.mdl")
	end
end

CLASS_STRIDER = CLASS.index
