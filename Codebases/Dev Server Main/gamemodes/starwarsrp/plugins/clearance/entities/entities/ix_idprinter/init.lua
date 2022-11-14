AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/cire992/props/computer02.mdl") 
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
    local ent = ents.Create("ix_idprinter")
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

function ENT:Use(activator, caller, useType, value)
    if (activator:IsPlayer()) then
        netstream.Start(activator, "OpenIDCreate", self:GetCreationID())
    end
end