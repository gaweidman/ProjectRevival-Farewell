
FACTION.name = "Overwatch Synthetic Arm"
FACTION.description = "A synthetic Overwatch soldier produced by the Combine."
FACTION.color = Color(88, 237, 14, 255)
FACTION.models = {"models/player.mdl"}
FACTION.isDefault = false
FACTION.isGloballyRecognized = true

function FACTION:OnCharacterCreated(client, character)
	if character:GetModel() == "models/hunter.mdl" then
		character:SetName("OSA.S08-HNT." .. Schema:ZeroNumber(math.random(1, 99999), 5), true)
	elseif character:GetModel() == "models/Combine_Strider.mdl" then
		character:SetName("OSA.S08-STR." .. Schema:ZeroNumber(math.random(1, 99999), 5), true)
	elseif character:GetModel() == "models/gunship.mdl" then
		character:SetName("OSA.S08-AFU." .. Schema:ZeroNumber(math.random(1, 99999), 5), true)
	elseif character:GetModel() == "models/combine_dropship.mdl" then
		character:SetName("OSA.S08-ATU." .. Schema:ZeroNumber(math.random(1, 99999), 5), true)
	elseif character:GetModel() == "models/elite_synth.mdl" then
		character:SetName("OSA.S08-FIST." .. Schema:ZeroNumber(math.random(1, 99999), 5), true)
	elseif character:GetModel() == "models/synth/elite_brown_pm.mdl" or character:GetModel() == "models/synth/elite_green_pm.mdl" then
		character:SetName("OSA.S08-NOMAD." .. Schema:ZeroNumber(math.random(1, 99999), 5), true)
	end

end

function FACTION:GetDefaultName(client)
	return "AWAITING ASSIGNMENT"
end

FACTION_OSA = FACTION.index
