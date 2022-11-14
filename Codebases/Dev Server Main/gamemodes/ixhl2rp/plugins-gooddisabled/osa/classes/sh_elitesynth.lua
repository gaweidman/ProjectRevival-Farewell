CLASS.name = "Elite Synth Soldier"
CLASS.faction = FACTION_OSA
CLASS.isDefault = false

function CLASS:OnSet(client)
	local character = client:GetCharacter()

	if (character) then
		character:SetName("OSA.C17-NOMAD." .. Schema:ZeroNumber(math.random(1, 99999), 5), true)
		character:SetModel("models/synth/elite_brown_pm.mdl")
	end
end

CLASS_ELITESYNTH = CLASS.index
