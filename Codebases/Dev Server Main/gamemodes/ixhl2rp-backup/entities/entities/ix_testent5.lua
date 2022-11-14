
AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Short Range Radio Jammer"
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
		
		self:SetModel("models/props_lab/powerbox02a.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)

		local physics = self:GetPhysicsObject()
		physics:EnableMotion(false)
		physics:Sleep()

		self:SetNetVar("On", false)
		self:SetNetVar("Battery", 100)
		
	end
	
	function ENT:Use(client, caller, useType)
		local jammerEnt = self
		if client:KeyDown(IN_WALK) then
			client:RequestString("Frequency", "What would you like to set the frequency to?", function(text)
				if client:GetEyeTrace().Entity == self and client:GetPos():Distance(self:GetPos()) <= 96 then
					if string.find(text, "^%d%d%d%.%d$") and tonumber(text) >= 100 and tonumber(text) < 200 then
						jammerEnt.frequency = text
						jammerEnt:EmitSound("buttons/lever7.wav", 50, math.random(170, 180), 75)
						client:Notify("You have successfully set the jammer's frequency.")
					else
						client:Notify("That is not a valid frequency!")
					end
				end
			end, jammerEnt.frequency or "000.0")
		else
			local newValue = !self:GetNetVar("On", true)
			self:SetNetVar("On", newValue)

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

		local lowBound, highBound = self:GetModelBounds()

		local forward = self:GetForward()
		local up = self:GetUp()
		local right = self:GetRight()

		local position = self:GetPos() + forward * 5.5 + up * 7.5

		local rectW = (highBound.y - lowBound.y )/ 0.1 - 16

		local percentage = (self:GetNetVar("Battery", 0))/100

		local batteryW = Lerp(percentage, 0, rectW - 4)

		local h = Lerp(percentage, 0, 120)

		cam.Start3D2D(position - lowBound.y*right, self:GetAngles() + Angle(0, 90, 90), 0.1)
			surface.SetDrawColor(color_black)
			surface.DrawRect(9, 20, rectW, 16)

			surface.SetDrawColor(color_white)
			surface.DrawRect(11, 22, batteryW, 12)

			draw.SimpleText(math.ceil(percentage*100).."%", "BudgetLabel", 11 + rectW/2 - 2, 20 + 12/2 + 2, HSVToColor(h, 1, 1), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		cam.End3D2D()

		render.SetMaterial(glowMaterial)
		render.DrawSprite(position + forward*0.75, 5, 5, color)
	end
end