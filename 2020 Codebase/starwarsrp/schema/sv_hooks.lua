hook.Add("PlayerSpawn", "SetBloodColor", function(ply)
    -- Fixes a bug where on join when the player isn't on a character,
    -- An error is thrown.
    if ply:GetCharacter() == nil then return end
    
    local faction = ply:GetCharacter():GetFaction()
    local class = ply:GetCharacter():GetClass()

    if (faction == FACTION_STORMTROOPER) then
        ply:SetBloodColor(BLOOD_COLOR_RED)
    elseif (faction == FACTION_NAVY) then
        ply:SetBloodColor(BLOOD_COLOR_RED)
    elseif (faction == FACTION_ARMY) then
        ply:SetBloodColor(BLOOD_COLOR_RED)
    elseif (faction == FACTION_ISB) then
        ply:SetBloodColor(BLOOD_COLOR_RED)
    elseif (faction == FACTION_DROID) then
        ply:SetBloodColor(DONT_BLEED)
    elseif (faction == FACTION_INQUIS) then
        ply:SetBloodColor(BLOOD_COLOR_RED)
    elseif (faction == FACTION_INSPEC) then
        ply:SetBloodColor(BLOOD_COLOR_RED)
    elseif (faction == FACTION_MISC) then
        ply:SetBloodColor(BLOOD_COLOR_RED)
    else
        ply:SetBloodColor(BLOOD_COLOR_RED)
    end
    
end)

hook.Add("PlayerSpawn", "SetHealthOnSpawn", function(ply)
    if ply:GetCharacter() == nil then return end

    local faction = ply:GetCharacter():GetFaction()
    local class = ply:GetCharacter():GetClass()

    if (faction == FACTION_DROID) then
        ply:ChatPrint("Droid")
        if (class == CLASS_DARKTROOPER) then
            ply:ChatPrint("hmmm")
            ply:SetHealth(500)
        end
    end
    
end)

netstream.Hook("SaveViewData", function(client, target, data)
    if (client:GetCharacter():GetClass() == CLASS_NAVYTROOPER or client:GetCharacter():GetFaction() == FACTION_ISB) then
        target:GetCharacter():SetData("securityData", data.securityData)
    end

    if (client:GetCharacter():GetFaction() == FACTION_ISB) then
        target:GetCharacter():SetData("isbData", data.isbData)
    end
end)
