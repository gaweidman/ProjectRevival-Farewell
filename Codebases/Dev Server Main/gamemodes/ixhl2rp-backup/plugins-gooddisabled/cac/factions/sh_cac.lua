
FACTION.name = "Combine Ancillary Commission"
FACTION.description = "A special unit made for busywork."
FACTION.color = Color(234, 140, 32, 255)
FACTION.models = {"models/player.mdl"}
FACTION.isDefault = false
FACTION.isGloballyRecognized = true

function FACTION:OnCharacterCreated(client, character)
	if character:GetModel() == "models/stalker.mdl" then
		character:SetName("CAC.C08-STK." .. Schema:ZeroNumber(math.random(1, 99999), 5), true)
	elseif character:GetModel() == "models/orion_hl2_beta/cremator.mdl" then
		character:SetName("CAC.C08-CRM." .. Schema:ZeroNumber(math.random(1, 99999), 5), true)
	end

end

function FACTION:GetDefaultName(client)
	return "AWAITING ASSIGNMENT"
end

FACTION_CAC = FACTION.index
