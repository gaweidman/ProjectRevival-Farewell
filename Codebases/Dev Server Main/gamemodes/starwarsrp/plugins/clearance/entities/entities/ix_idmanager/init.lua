AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/cire992/props/computerscreen.mdl") 
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then phys:Wake() end
end

-- Called when the entity is spawned.
function ENT:SpawnFunction( ply, tr )
    if ( !tr.Hit ) then return end
    local ent = ents.Create("ix_idmanager")
    ent:SetPos( tr.HitPos + tr.HitNormal * 16 )
    ent:Spawn()
    ent:Activate()
    ent:SetUseType(SIMPLE_USE)
    
    return ent
end

function ENT:OnRemove()
end

function ENT:Think()
end

function ENT:StartTouch(other)
end

function ENT:Use(activator, caller, useType, value)
    if (activator:IsPlayer()) then
        local hasId = false
        local idItem = null

        local inv = activator:GetCharacter():GetInventory()

        for k, v in pairs(inv:GetItemsByUniqueID("identichip", true)) do
            hasId = true
            idItem = v
        end

        if (!hasId) then
            return
        else
            local rank = idItem:GetData("rank", CLASS_STORMTROOPER)
            local classTable = ix.class.Get(idItem:GetData("class", 1))
            local dataTbl = {
                self:GetCreationID(),
                idItem:GetData("clearance", {
                    ["control"] = 0,
                    ["systems"] = 0,
                    ["isb"] = 0 
                }),
                idItem:GetData("charName", "UNDEFINED"),
                idItem:GetData("rankName", "UNDEFINED"),
                idItem:GetData("org", "UNDEFINED"),
                idItem:GetData("role", "UNDEFINED"),
                idItem:GetData("class", 1)
            }
            netstream.Start(activator, "OpenIDManager", dataTbl)
        end
    end
end