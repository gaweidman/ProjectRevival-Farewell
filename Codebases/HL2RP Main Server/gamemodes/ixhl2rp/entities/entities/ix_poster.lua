
AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Poster Entity"
ENT.Category = "HL2 RP"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.PhysgunDisable = true
ENT.bNoPersist = true
ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:Initialize()
	self:SetModel("models/props_c17/doll01.mdl")
	self:DrawShadow(false)
end

function ENT:SetImage( image )
	if SERVER then
		self:SetNetVar("Image", image)
	else
		material = Material("../data/helix/projectrevival/"..image, "noclamp smooth")

		if (!material:IsError()) then
			self.material = material

			-- Set width and height
			self.matW = material:GetInt("$realwidth")
			self.matH = material:GetInt("$realheight")
		end
	end
end

function ENT:OnTakeDamage( damage ) 
	
end

function ENT:Think()
	--print( self:GetNetVar("ServerImage", nil))
	if CLIENT then
		if !self.material then
			local image = self:GetNetVar("Image", nil)

			if image then
				self:SetImage(image)
			end
		end

		if self.matW == nil then
			self.matW = material:GetInt("$realwidth")
			self.matH = material:GetInt("$realheight")
		end

		
	end

	--print(self.matW)

	
end

function ENT:Touch( entity )

end

if (CLIENT) then

	function ENT:Draw()
		local scale = 0.15
		cam.Start3D2D(self:GetPos() + self.matW*self:GetRight()*scale/2  + self.matH*self:GetUp()*scale/2 + self:GetForward(), self:GetAngles() + Angle(0, 90, 90), scale)
			local mat = self.material
			if mat then
				render.PushFilterMin(TEXFILTER.ANISOTROPIC)
				render.PushFilterMag(TEXFILTER.ANISOTROPIC)
					surface.SetDrawColor(255, 255, 255)
					surface.SetMaterial(mat)
					surface.DrawTexturedRect(0, 0, self.matW, self.matH)
				render.PopFilterMag()
				render.PopFilterMin()
			end

		--surface.SetDrawColor(255, 255, 255)
		--surface.DrawRect(0, 0, 500, 500)
			
		cam.End3D2D()
	end

end