
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.Size = 0.75

/*---------------------------------------------------------
Initialize
---------------------------------------------------------*/
function ENT:Initialize()

	self:SetModel("models/weapons/mininuke.mdl")
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:DrawShadow( true )
	self.AllowEXP = false

	self.DummyTime = CurTime() + 20
	self.Removal = CurTime() + 15
	
--	self:GetPhysicsObject():Wake()
	
	self:SetCollisionGroup( COLLISION_GROUP_WORLD )

end

/*---------------------------------------------------------
Think
---------------------------------------------------------*/
function ENT:Think()
if self.Removal and CurTime() >= self.Removal then
self.Removal = nil
self:Remove()
end
end

/*---------------------------------------------------------
Explosion
---------------------------------------------------------*/
function ENT:Explosion()
end

function ENT:Touch(ent)
end