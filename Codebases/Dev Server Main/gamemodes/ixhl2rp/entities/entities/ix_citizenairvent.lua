
AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Citizen Air Vent"
ENT.Category = "HL2 RP"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.PhysgunDisable = true
ENT.bNoPersist = true


if (SERVER) then
	function ENT:Initialize()
		self:SetModel("models/props_wasteland/prison_heater001a.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
	end	
end

