CLASS.name = "Dropship"
CLASS.faction = FACTION_OSA
CLASS.isDefault = false

function CLASS:OnSet(client)
	local character = client:GetCharacter()

	if (character) then
		character:SetName("OSA.S17-ATU." .. Schema:ZeroNumber(math.random(1, 99999), 5), true)
		character:SetModel("models/combine_dropship.mdl")
	end
end

CLASS_DROPSHIP = CLASS.index
