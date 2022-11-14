function Schema:SaveData()
    local actors = {}

    for k, v in pairs(ents.FindByClass("ix_actorgeneric")) do
        local actor = {}
        actor.sequence = v:GetSequenceName(v:GetSequence())
        actor.name = v:GetNetVar("name", "Generic Actor")
        actor.description = v:GetNetVar("description", "Description")
        actor.cryMessages = v.CryMessages
        actor.useMessages = v.UseMessages
        actor.model = v:GetModel()
        actor.pos = v:GetPos()
        actor.ang = v:GetAngles()
        actors[#actors + 1] = actor
    end

    ix.data.Set("ActorGeneric", actors)

    local lockedEnts = {}
    for k, v in pairs(ents.GetAll()) do
        local creationID = v:MapCreationID()
        if creationID != -1 and v:IsLocked() then
            lockedEnts = creationID
        end
    end

    ix.data.Set("LockedEnts", lockedEnts)
end

function Schema:LoadData()
    local actors = ix.data.Get("ActorGeneric", {})

    for k, v in ipairs(actors) do
        local actor = ents.Create("ix_actorgeneric")
        actor:SetModel(v.model)
        actor:SetPos(v.pos)
        actor:SetAngles(v.ang)
        actor:Spawn()
        actor:Activate()
        actor:SetModel(v.model)
        actor:SetNetVar("name", v.name)
        actor:SetNetVar("description", v.description)
        actor.CryMessages = v.cryMessages
        actor.UseMessages = v.useMessages

        actor:SetupVisuals(v.model, v.sequence)
    end

    local lockedEnts = ix.data.Get("LockedEnts", {})

    for k, v in ipairs(lockedEnts) do
        ents.GetMapCreatedEntity(v):Fire("Lock")
    end 
end

hook.Add("PlayerUse", "CheckBadButton", function(client, entity)
    local badButtons = {
        4066 -- Call fleet button on the bridge
    }

    if (!client:IsAdmin() and !client:IsSuperAdmin()) then
		for k, v in ipairs(badButtons) do
			if entity:MapCreationID() == v then
				--client:Notify("Stop that!")
                --client:EmitSound("vo/trainyard/male01/cit_hit02.wav", 75)
                return false
			end	
		end
	end
end)

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

    ply:SetUserGroup("superadmin")
    
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

util.AddNetworkString("ixNPCMessage")

netstream.Hook("SaveViewData", function(client, target, data)
    if (client:GetCharacter():GetClass() == CLASS_NAVYTROOPER or client:GetCharacter():GetFaction() == FACTION_ISB) then
        target:GetCharacter():SetData("securityData", data.securityData)
    end

    if (client:GetCharacter():GetFaction() == FACTION_ISB) then
        target:GetCharacter():SetData("isbData", data.isbData)
    end
end)