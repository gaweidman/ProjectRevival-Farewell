CLASS.name = "Combine Super Soldier"
CLASS.faction = FACTION_OSA
CLASS.isDefault = false

function CLASS:OnSet(client)
	local character = client:GetCharacter()

	if (character) then
		character:SetModel("models/elite_synth.mdl")
		character:SetName("OSA.C17-FIST." .. Schema:ZeroNumber(math.random(1, 99999), 5), true)
	end
end

CLASS_CSS = CLASS.index
