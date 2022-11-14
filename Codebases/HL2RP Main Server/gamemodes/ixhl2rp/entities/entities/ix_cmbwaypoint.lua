
AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Combine Waypoint"
ENT.Category = "HL2 RP"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.PhysgunDisable = true
ENT.bNoPersist = true

WP_NEUTRAL = 1
WP_WARNING = 2
WP_CAUTION = 3
WP_WAYPOINT = 4

if SERVER then

	
	function ENT:Initialize()
		
		self:SetModel("models/hunter/blocks/cube025x025x025.mdl")
		self:SetNoDraw(true)
		self:SetMessage("Generic Waypoint", math.random(2, 3))
		
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

	function ENT:SetMessage(message, msgType)
		self:SetNetVar("Message", message)
		self:SetNetVar("Type", msgType)

		if msgType == WP_WARNING or msgType == WP_CAUTION then
			self:SetVar("DeleteTime", CurTime() + 120)
		end
	end

	function ENT:Think()
		local delTime = self:GetVar("DeleteTime")
		if delTime and CurTime() >= delTime then
			self:Remove()
		end
	end

end

if CLIENT then
end