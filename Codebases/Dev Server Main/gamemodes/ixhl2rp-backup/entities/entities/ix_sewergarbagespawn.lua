
AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Searchable Garbage Spawn"
ENT.Category = "HL2 RP"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.PhysgunDisable = true


ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

if (SERVER) then
	function ENT:Initialize()
		self:SetModel("models/hunter/blocks/cube025x025x025.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)

		self:DrawShadow(false)

		self:SetVar("NextSpawn", CurTime() + math.random(15, 20))

	end

	function ENT:Think()
		if !IsValid(self.garbageEnt) and CurTime() >= self:GetVar("NextSpawn", -1) then
			for k, v in ipairs(player.GetAll()) do
				if v:VisibleVec(self:GetPos()) then
					return
				end
			end
			self.garbageEnt = ents.Create("ix_sewergarbage")
			self.garbageEnt:SetPos(self:GetPos())
			self.garbageEnt:SetAngles(Angle(0, math.random(0, 360), 0))
			self.garbageEnt:SetParent(self)
			self.garbageEnt:Spawn()
			
		end
	end

end