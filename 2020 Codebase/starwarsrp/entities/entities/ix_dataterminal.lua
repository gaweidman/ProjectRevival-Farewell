
AddCSLuaFile()

ENT.Base = "base_entity"
ENT.Type = "anim"
ENT.PrintName = "Data Terminal"
ENT.Category = "Helix - Project Revival"
ENT.Spawnable = true

if (SERVER) then
	function ENT:Initialize()
		self:SetModel("models/cire992/props/computerscreen.mdl") 
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then phys:Wake() end
	end
end

if (CLIENT) then
	function ENT:Draw()
		self.Entity:DrawModel()
	
		local yaw = self:GetAngles()[2]
		cam.Start3D2D(self:GetPos() + Vector(0, 0, 12), Angle(0, yaw+90, 75), 0.1)
			draw.DrawText("Data Terminal", "ScoreboardDefaultTitle", 0, 0, Color(55, 110, 183), TEXT_ALIGN_CENTER)
		cam.End3D2D()
	end
end