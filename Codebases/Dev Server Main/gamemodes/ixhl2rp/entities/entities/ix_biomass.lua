
AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Xenian Spores"
ENT.Category = "HL2 RP"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.PhysgunDisable = true
ENT.bNoPersist = true

if SERVER then

	function ENT:Initialize()
		self:SetModel("models/hunter/blocks/cube025x025x025.mdl")
		self:PhysicsInit(SOLID_NONE)
		self:SetSolid(SOLID_NONE)
		self:SetUseType(SIMPLE_USE)
		self:SetNoDraw(true)

		self.createTime = os.time()
	end

	function ENT:Think()
		if os.time >= self.createTime + 1440*24 then
			local thisPos = self:GetPos()
			for k, v in ipairs(player.GetAll()) do
				if !self:TestPVS(v) or thisPos:Distance(v:GetPos()) <= 500 then
					return 
				end
			end

			self:Remove()
			local mass = ents.Create("ix_biomass")
			mass:SetPos(self:GetPos())
			mass:SetAngles(Angle(0, math.random(0, 360), 0))
		end
	end
end