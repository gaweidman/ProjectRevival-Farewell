
FACTION.name = "Overwatch Transhuman Arm"
FACTION.description = "A transhuman Overwatch soldier produced by the Combine."
FACTION.color = Color(150, 50, 50, 255)
FACTION.bgImage = "vgui/project-revival/CombineBG.png"
FACTION.models = {"models/hlvr/characters/combine/grunt/combine_grunt_hlvr_npc.mdl"}
FACTION.isDefault = false
FACTION.isGloballyRecognized = false
FACTION.runSounds = {[0] = "NPC_CombineS.RunFootstepLeft", [1] = "NPC_CombineS.RunFootstepRight"}

function FACTION:OnCharacterCreated(client, character)
	local inventory = character:GetInventory()

	inventory:Add("pistol", 1)
	inventory:Add("pistolammo", 2)

	inventory:Add("smg1", 1)
	inventory:Add("smg1ammo", 2)
end

function FACTION:GetDefaultName(client)
	return "OTA.C17-ECHO.OHZ." .. Schema:ZeroNumber(math.random(1, 99999), 5), true
end

FACTION_OTA = FACTION.index
