
AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Health Charger"
ENT.Category = "HL2 RP"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.PhysgunDisable = true
ENT.bNoPersist = true


if (SERVER) then
	function ENT:Initialize()
		self:SetModel("models/props_wasteland/laundry_dryer001.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)

		local physics = self:GetPhysicsObject()
		physics:EnableMotion(false)
		physics:Sleep()
		
		self.totalHP = 50
	end

	function ENT:SpawnFunction(client, trace)
		local vendor = ents.Create("ix_testent2")

		vendor:SetPos(trace.HitPos)
		vendor:SetAngles(Angle(0, (vendor:GetPos() - client:GetPos()):Angle().y - 180, 0))
		vendor:Spawn()
		vendor:Activate()

		return vendor
	end

	function ENT:Use(client, caller, useType)
		self:DispenseMoney()

	end

	function ENT:DispenseMoney()
		self:SetNetVar("DispenseTime", CurTime())
		self:SetNetVar("Opening", true)
		self:EmitSound("doors/door_metal_rusty_move1.wav")
		timer.Simple(1.25, function()
			self:EmitSound("doors/door_metal_thin_close2.wav")
			timer.Simple(0.35, function()
				self:EmitSound("ambient/machines/combine_terminal_idle2.wav")
			end)
			timer.Simple(0.5, function()
				local position = self:GetPos() + self:GetUp() * -15 + self:GetForward() * 30 + self:GetRight() * 23.75
				
				
				ix.currency.Spawn(position, 5, angle_zero)
				timer.Simple(0.5, function()
					
					self:EmitSound("doors/door_metal_rusty_move1.wav")
					self:SetNetVar("DispenseTime", CurTime())
					self:SetNetVar("Opening", false)
					timer.Simple(1.25, function()
						self:EmitSound("doors/door_metal_thin_close2.wav")
					end)
				end)
			end)
			
			
		end)
	end
		
end

if (CLIENT) then
	local glowMaterial = ix.util.GetMaterial("sprites/glow04_noz")
	local color_ready = Color(0, 255, 0, 255)
	local color_busy = Color(255, 150, 0, 255)
	local doorMat = Material("models/props_lab/door_klab01")
	local doorTex = doorMat:GetTexture("$basetexture")

	function ENT:Draw()
		local isFree = self:GetNetVar("isFree", true)
		local dispenseTime = self:GetNetVar("DispenseTime", nil)
		local opening = self:GetNetVar("Opening", false)
		self:DrawModel()
		local color
		local screenText

		if !isFree then
			color = color_busy
			screenText = "BUSY"
		
		elseif dispenseTime and dispenseTime + 1.3 >= CurTime() or opening then
			screenText = "DISPENSING"
			color = color_busy
		else
			color = color_ready
			screenText = "READY"
		end

		--if dispenseTime and dispenseTime + 1.25 > CurTime() then dispenseTime = nil end

		local up = self:GetUp()
		local forward = self:GetForward()
		local right = self:GetRight()*20

		local position = self:GetPos() + self:GetUp() * -4 + self:GetForward() * 26 + self:GetRight() * 23.75

		local basePos = self:GetPos()

		local lowBound, highBound = self:GetCollisionBounds()
		local boundDiff = highBound + lowBound
		boundDiff = boundDiff

		local screenW = 40

		local screenPos = basePos + forward * 24.7

		cam.Start3D2D(screenPos + Vector(0, screenW/2, 0), self:GetAngles() + Angle(0, 90, 90), 0.1)
			surface.SetDrawColor(color_black)
			local rectW = screenW*10
			local rectH = 50
			surface.DrawRect(10, 0, rectW, rectH)
			draw.SimpleText(screenText, "DermaLarge", rectW/2 + 10, rectH/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			surface.SetDrawColor(175, 175, 175)
			surface.DrawOutlinedRect(10, 0, rectW, 50, 2)

		cam.End3D2D()

		
			
		local drawPos = self:GetPos() + self:GetUp() * -15 + self:GetForward() * 24.55 + self:GetRight() * 28
		local to, from
		local lerpFrac
		local closeW 
		if dispenseTime then
			

			if !opening then
				to = 0
				from = 70
			else
				to = 70
				from = 0
			end

			cam.Start3D2D(drawPos, self:GetAngles() + Angle(0, 90, 90), 0.1)
				lerpFrac = (CurTime() - dispenseTime)/1.25
				closeW = Lerp(lerpFrac, from, to)

				surface.SetDrawColor(color_black)
				surface.DrawRect(7, 70-closeW, 70, closeW)

				surface.SetMaterial(doorMat)
				surface.SetDrawColor(color_white)
				--surface.DrawTexturedRect(7, 0, 70, 70)

				--render.DrawTextureToScreenRect(doorTex, 7, 0, 70, 70)
			cam.End3D2D()
		end

		render.SetColorMaterial() -- white material for easy coloring
		render.SetMaterial(doorMat)
		--cam.IgnoreZ( false )

		if closeW then

			local shutterW = 7 - closeW/10
			
			render.DrawBox(drawPos + self:GetRight()*-0.7 + self:GetForward()*-0.1 + Vector(0, -3.5, 3.5) - self:GetUp()*shutterW, self:GetAngles() + Angle(180, 0, 0), Vector(-0.1, -3.5, -3.5), Vector(0.1, 3.5, 3.5), color_white)
			
		else
			render.DrawBox(drawPos + self:GetRight()*-0.7 + self:GetForward()*-0.1 + Vector(0, -3.5, -3.5), self:GetAngles() + Angle(180, 0, 0), Vector(-0.1, -3.5, -3.5), Vector(0.1, 3.5, 3.5), color_white)
		end
		render.SetMaterial(glowMaterial)
		render.DrawSprite(position, 10, 10, color)
	end

end
