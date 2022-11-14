local entityMeta = FindMetaTable("Entity")

function entityMeta:GetBaseDT()

    if self:IsPlayer() then
        local char = self:GetCharacter()
        local model = self:GetModel()
        local faction = char:GetFaction()
        local class = char:GetClass()
        if faction == FACTION_CITIZEN then return 0
        elseif faction == FACTION_CCA and self:GetModel() == "models/police_nemez.mdl" then return 5
        elseif faction == FACTION_OTA then

            if model == "models/romka/romka_combine_soldier.mdl" then return 8
            elseif model == "models/hlvr/characters/combine/grunt/combine_grunt_hlvr_npc.mdl" then return 5
            elseif model == "models/hlvr/characters/combine/heavy/combine_heavy_hlvr_npc.mdl" then return 16
            elseif model == "models/hlvr/characters/combine_captain/combine_captain_hlvr_npc.mdl" then return 12
            elseif model == "models/hlvr/characters/combine/suppressor/combine_suppressor_hlvr_npc.mdl" then return 14
            elseif model == "models/romka/rtb_elite.mdl" then return 15 end

        elseif faction == FACTION_CONSCRIPT then
            local model == self:GetModel()

            if self:IsFemale() then
                if self:GetBodygroup(1)
            else
                local totalDt = 0
                if string.find(model, "novest", 1, true) then 
                    totalDt = totalDt + 6
                end 

                if self:GetBodygroup(1) == 1 then totalDt = totalDt + 1
            end
        elseif faction == FACTION_OSA then

            if class == IXCLASS_HUNTER then return 8
            elseif class == IXCLASS_STALKER then return 0
            elseif class == IXCLASS_CMBGUARD then return 18
            elseif class == IXCLASS_AASSASSIN then return 5 end

        elseif faction == FACTION_ALIEN then

            if class == IXCLASS_ZOMBIE then return 0
            elseif class == IXCLASS_FASTZOMBIE then return 0
            elseif class == IXCLASS_POISONZOMBIE then return 3
            elseif class == IXCLASS_HC then return 0
            elseif class == IXCLASS_FASTHC then return 0
            elseif class == IXCLASS_BLACKHC then return 0
            elseif class == IXCLASS_ANTLION then return 5
            elseif class == IXCLASS_ANTLIONGUARD then return 1
            elseif class == IXCLASS_VORTIGAUNT then return 7
            elseif class == IXCLASS_HOUNDEYE then return 0
            elseif class == IXCLASS_BULLSQUID then return 1
            elseif class == IXCLASS_STROOPER then return 2
            elseif class == IXCLASS_PITDRONE then return 1 end

        elseif faction == FACTION_CAC then
            
            if class == IXCLASS_CREMATOR then return 3
            elseif class == IXCLASS_VORTSLAVE then return 7

        end
    else
        local class = self:GetClass()

        if class == 0 then end
    end
end

function entityMeta:IsOneHanded()
    if !self:IsWeapon() then return nil end

    local holdType = self:GetHoldType()

    return holdType == "pistol" or holdType == "grenade" or holdType == "revolver"
end

function entityMeta:IsTwoHanded()
    return !self:IsOneHanded()
end