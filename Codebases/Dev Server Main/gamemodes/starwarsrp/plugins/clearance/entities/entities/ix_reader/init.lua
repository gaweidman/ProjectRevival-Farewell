AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

MODE_SWIPE_CARD = {
    ["enum"] = 1, 
    ["msg"] = "Swipe\nCard", 
    ["color"] = Color(255, 255, 255)
}

MODE_ACCESS_GRANTED = {
    ["enum"] = 2, 
    ["msg"] = "Access\nGranted", 
    ["color"] = Color(40, 255, 40)
}

MODE_ACCESS_DENIED = {
    ["enum"] = 3, 
    ["msg"] = "Access\nDenied", 
    ["color"] = Color(255, 40, 40)
}

MODE_OPEN = {
    ["enum"] = 4, 
    ["msg"] = "Open", 
    ["color"] = Color(40, 255, 40)
}

MODE_LOCKDOWN = {
    ["enum"] = 5, 
    ["msg"] = "Locked\nDown", 
    ["color"] = Color(255, 40, 40)
}

MODE_NO_CARD = {
    ["enum"] = 6, 
    ["msg"] = "No Card\nDetected", 
    ["color"] = Color(255, 40, 40)
}

MODE_UNDEFINED = {
    ["enum"] = 7, 
    ["msg"] = "UNDEFINED", 
    ["color"] = Color(255, 40, 255)
}

function ENT:Initialize()
	self:SetModel("models/lt_c/holo_keypad.mdl") 
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    
	local phys = self:GetPhysicsObject()
    if phys:IsValid() then phys:Wake() end
    
    self:SetNetVar("statusWaitEnd", -1)
end

-- Called when the entity is spawned.
function ENT:SpawnFunction( ply, tr )
    if ( !tr.Hit ) then return end
    local ent = ents.Create("ix_reader")
    ent:SetPos( tr.HitPos + tr.HitNormal * 16 )
    ent:Spawn()
    ent:Activate()
    ent:SetUseType(SIMPLE_USE)

    ent:SetNetVar("mode", MODE_SWIPE_CARD)

    return ent
end

function ENT:OnRemove()
end

function ENT:Think()
    local statusWaitEnd = self:GetNetVar("statusWaitEnd", -1)
    local mode = self:GetNetVar("mode", MODE_UNDEFINED).enum
    if (CurTime() >= statusWaitEnd and statusWaitEnd != -1 and mode == MODE_ACCESS_GRANTED.enum) then
        self:SetLockMode(MODE_SWIPE_CARD)
        for k, v in ipairs(ents.GetAll()) do
            for k2, v2 in pairs(self:GetNetVar("linkedDoors")) do
                if (v:MapCreationID() == v2) then
                    v:Fire("Close")
                    v:Fire("Lock")
                    self:SetNetVar("statusWaitEnd", -1)
                end
            end
        end
        self:SetNetVar("statusWaitEnd", -1)
    elseif (CurTime() >= statusWaitEnd and statusWaitEnd != -1 and (mode == MODE_ACCESS_DENIED.enum or mode == MODE_NO_CARD.enum)) then
        self:SetLockMode(MODE_SWIPE_CARD)
        print("yeah, i'm here")
        self:SetNetVar("statusWaitEnd", -1)
    end
end

function ENT:Use(activator, caller, useType, value)
    if (activator:IsPlayer() and self:GetNetVar("mode", MODE_UNDEFINED).enum == MODE_SWIPE_CARD.enum) then
        local hasId = false
        local idItem = null

        local inv = activator:GetCharacter():GetInventory()

        -- Makes sure you can't use the reader while an access granted/denied message is being displayed.
        if (self:GetNetVar("statusWaitEnd", -1) != -1) then
            return
        end

        local hasId = false
        local idItem = null
        for k, v in pairs(inv:GetItemsByUniqueID("identichip", true)) do
            hasId = true
            idItem = v
        end

        if (!hasId) then
            self:SetLockMode(MODE_NO_CARD)
            self:SetNetVar("statusWaitEnd", CurTime() + ix.config.Get("cardSwipeCooldown", 3))
            return
        end
        
        local itemClrTbl = idItem:GetData("clearance", {
            ["control"] = 0,
            ["systems"] = 0,
            ["isb"] = 0
        })

        local selfClrType = self:GetNetVar("reqClr", {})["type"]
        local selfClrLvl = self:GetNetVar("reqClr", {})["level"]

        --[[
            Checks if the item's clearance level is higher than the reader's required clearance level.
            The code looks so strange because it uses the required level as an index to get the item's
            clearance level for that type.
        ]]--
        if (itemClrTbl[selfClrType] >= selfClrLvl) then 
            self:SetLockMode(MODE_ACCESS_GRANTED)
            self:SetNetVar("statusWaitEnd", CurTime() + 5)
            for k, v in ipairs(ents.GetAll()) do
                if (v == 1809) then
                    --print("match but lesser")
                end
                for k2, v2 in pairs(self:GetNetVar("linkedDoors", {})) do      
                    if (v:MapCreationID() == v2) then
                        v:Fire("Unlock")
                        v:Fire("Open")
                    end
                end
            end
            return
        else
            self:SetLockMode(MODE_ACCESS_DENIED)
            self:SetNetVar("statusWaitEnd", CurTime() + ix.config.Get("cardSwipeCooldown", 3))
            return
        end
    end
end

function ENT:SetLockMode(mode)
    self:SetNetVar("mode", mode)
end

function ENT:GetLockMode()
    self:GetNetVar("mode", MODE_UNDEFINED)
end

function ENT:AccessGranted()
    self:SetLockMode(MODE_ACCESS_GRANTED)
    for k, v in ipairs(ents.GetAll()) do
        for k2, v2 in pairs(self:GetNetVar("linkedDoors")) do
            if (v:MapCreationID() == v2) then
                v:Fire("Unlock")
                self:SetNetVar("statusWaitEnd", CurTime() + ix.config.Get("cardSwipeCooldown", 3))
            end
        end
    end
end

function ENT:AccessDenied()
    self:SetLockMode(MODE_ACCESS_DENIED)
    self:SetNetVar("statusWaitEnd", CurTime() + ix.config.Get("cardSwipeCooldown", 3))
end