
AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Bell"
ENT.Category = "HL2 RP"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.PhysgunDisable = true
ENT.bNoPersist = true

if SERVER then

	function ENT:Initialize()
		
		self:SetModel("models/hunter/blocks/cube025x025x025.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)

		self.bellID = #
		
	end

	function ENT:Use(client, caller, useType)
		client:Notify("You ring the bell.")
		for _, ply in ipairs(player.GetAll()) do
			ply:ChatPrint("[DEBUG] A bell has been rung.")
			local char = ply:GetCharacter()
			
			local pager = char:GetInventory():HasItem("pager")
			if pager then
				local bellID = pager:GetData("BellID", nil) 
				if bellID == self.bellID then
					ply:Notify("Your pager is vibrating.")
				end
			end
		end
	end

	function ENT:SetBellID()
		self.bellID = math.random(1, 2048)


		for k, v in ipairs(ents.FindByClass("ix_bell")) do
			if v.bellID == self.bellID then
				print("Reshuffling bell ID")
				self:SetBellID()
				return
			end
		end

		print("Bell ID successfully set.")
	end
end