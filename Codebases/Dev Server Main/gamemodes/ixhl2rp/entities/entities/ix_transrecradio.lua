
AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Transmit-Receive Radio"
ENT.Category = "HL2 RP"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.PhysgunDisable = true
ENT.bNoPersist = true

if SERVER then
	startTable = {}
	cookingTable = {}
	cookedTable = {}
	burntTable = {}
	
	function ENT:Initialize()
		
		self:SetModel("models/props_lab/citizenradio.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)

		local physics = self:GetPhysicsObject()
		physics:EnableMotion(false)
		physics:Sleep()

		self:SetNetVar("On", false)
		self:SetSkin(1)
		
	end
	

	function ENT:Use(client, caller, useType)
		local radioEntity = self
		if client:KeyDown(IN_WALK) then

			net.Start("ixOpenRadioMenu")
				net.WriteString(self.frequency or "000.0")
				net.WriteUInt(self.volume or 100, 7)
			net.Send(client)

			/*


			client:RequestString("Frequency", "What would you like to set the frequency to?", function(text)
				
			end, radioEntity.frequency or "000.0")

			*/

		else
			local newValue = !self:GetNetVar("On", true)
			self:SetNetVar("On", newValue)

			if newValue then
				self:SetSkin(0)
			else
				self:SetSkin(1)
			end

			self:EmitSound("buttons/lightswitch2.wav")
		end
	end

end

local onColor = Color(0, 255, 0)
local offColor = Color(255, 0, 0)

if CLIENT then
	local glowMaterial = ix.util.GetMaterial("sprites/glow04_noz")
	
	function ENT:Draw()
		self:DrawModel()

		local color

		if self:GetNetVar("On", false) then
			color = onColor
		else
			color = offColor
		end

		local position = self:GetPos() + self:GetForward() * 10 + self:GetUp() * 7.5 + self:GetRight() * -8.75

		render.SetMaterial(glowMaterial)
		render.DrawSprite(position, 5, 5, color)
	end
end