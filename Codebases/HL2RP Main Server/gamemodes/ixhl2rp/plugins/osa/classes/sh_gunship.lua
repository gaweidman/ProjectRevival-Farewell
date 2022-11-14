CLASS.name = "Gunship"
CLASS.faction = FACTION_OSA
CLASS.isDefault = false

function CLASS:OnSet(client)
	local character = client:GetCharacter()

	if (character) then
		character:SetName("OSA.C17-AFU." .. Schema:ZeroNumber(math.random(1, 99999), 5), true)
		character:SetModel("models/gunship.mdl")
	end
end

CLASS_GUNSHIP = CLASS.index
