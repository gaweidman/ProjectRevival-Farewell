
FACTION.name = "Universal Union"
FACTION.description = "A transhuman Overwatch soldier produced by the Combine."
FACTION.color = Color(168, 19, 19, 255)
FACTION.models = {"models/hlvr/characters/combine/grunt/combine_grunt_hlvr_npc.mdl"}
FACTION.isDefault = false
FACTION.isGloballyRecognized = true
FACTION.runSounds = {[0] = "NPC_CombineS.RunFootstepLeft", [1] = "NPC_CombineS.RunFootstepRight"}

function FACTION:OnCharacterCreated(client, character)
	local inventory = character:GetInventory()

	inventory:Add("pulsesmg", 1)
	inventory:Add("ar2ammo", 2)
end

function FACTION:GetDefaultName(client)
	return "UU-CmD.17"
end

FACTION_UU = FACTION.index
