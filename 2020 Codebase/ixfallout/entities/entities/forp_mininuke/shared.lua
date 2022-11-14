ENT.Type = "anim"
ENT.PrintName		= "Mini Nuke"
ENT.Author			= "Zoey & Stef"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

/*---------------------------------------------------------
OnRemove
---------------------------------------------------------*/
function ENT:OnRemove()
end

/*---------------------------------------------------------
PhysicsUpdate
---------------------------------------------------------*/
function ENT:PhysicsUpdate()
end

/*---------------------------------------------------------
PhysicsCollide
---------------------------------------------------------*/
function ENT:PhysicsCollide( data, physobj )
local LastSpeed = data.OurOldVelocity:Length()
	local NewVelocity = physobj:GetVelocity()
	local NormVel = data.OurOldVelocity:GetNormal()
 
	NewVelocity:Normalize()
	local TargetVelocity = NewVelocity * LastSpeed * 0.4

	physobj:SetVelocity(TargetVelocity)
end
