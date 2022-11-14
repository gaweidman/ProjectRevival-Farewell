CLASS.name = "Hunter"
CLASS.faction = FACTION_OSA
CLASS.isDefault = false

function CLASS:OnSet(client)
	local character = client:GetCharacter()

	if (character) then
		character:SetName("OSA.S17-HNT." .. Schema:ZeroNumber(math.random(1, 99999), 5), true)
		character:SetModel("models/hunter.mdl")
	end
end

CLASS_HUNTER = CLASS.index
