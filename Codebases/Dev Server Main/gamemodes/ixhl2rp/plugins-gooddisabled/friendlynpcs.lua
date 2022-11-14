local PLUGIN = PLUGIN
PLUGIN.name = "Smart Combine NPC's"
PLUGIN.description = "Fixes certian npc's getting angy at MPF"
PLUGIN.author = "liquid, Ghost"

if not SERVER then return end

function PLUGIN:Think()
    self.nextRunTime = self.nextRunTime or 0
    if self.nextRunTime > CurTime() then return end
    self.nextRunTime = CurTime() + 0.5

    local friendlyNPCs = {
        "npc_combine_camera",
        "npc_manhack",
        "npc_turret_floor",
        "npc_turret_ceiling",
        "npc_combine_s",
        "npc_metropolice",
        "npc_cscanner",
        "npc_strider",
        "npc_clawscanner",
        "npc_combinegunship",
        "npc_combinedropship",
        "npc_hunter",
        "npc_helicopter",
        "npc_combineredone_e",
        "npc_hla_combine_commander",
        "npc_hla_combine_grunt",
        "npc_hla_combine_heavy",
        "npc_hla_combine_sup",
        "npc_hla_combine_vannila",
        "npc_hl_a_hazmat_worker_ho",
        "npc_hl_a_hazmat2_worker_ho",
        "npc_hostile_hlvr_combine_worker.vmt",
        "npc_hostile_hlvr_hazmat_workernpc_hostile_hlvr_hazmat_worker",
        "npc_hlvr_cheavy_s"
    }
    
    for _, className in ipairs(friendlyNPCs) do
        for _, npc in ipairs(ents.FindByClass(className)) do
            for _, ply in ipairs(player.GetAll()) do
                npc:AddEntityRelationship( ply, (ply:HasBiosignal() or ply:IsDispatch()) and D_HT or D_FR, 99)
            end
        end
    end

    local meanNPCs = {
    	"npc_citizen",
    	"npc_vortigaunt"
    }
    
    for _, className in ipairs(meanNPCs) do
        for _, npc in ipairs(ents.FindByClass(className)) do
            for _, ply in ipairs(player.GetAll()) do
                npc:AddEntityRelationship( ply, npc:AddEntityRelationship( ply, (ply:HasBiosignal() or ply:IsDispatch() or ply:GetFaction() == FACTION_CONSCRIPT) and D_HT or D_FR, 99), 99)
            end
        end
    end
    
end
