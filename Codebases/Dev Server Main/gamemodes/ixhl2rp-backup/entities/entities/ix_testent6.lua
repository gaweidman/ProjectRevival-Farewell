--[[
	Copyright 2018 Lex Robinson

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

		http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
--]]
AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.PrintName = "Apartment Manager"
ENT.Author    = "QIncarnate"
ENT.Spawnable = true
ENT.Category  = "Dev Stuff"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT


function ENT:Initialize()

	self:SetModel( "models/props_combine/combine_intmonitor003.mdl" )
	if SERVER then
		self:SetUseType(SIMPLE_USE)
		self:PhysicsInit( SOLID_VPHYSICS )
		--self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		local physObj = self:GetPhysicsObject()
		--physObj:EnableCollisions(false)

		self:SetSkin(0)

		/*


		self.collision = ents.Create("prop_dynamic")
		self.collision:SetModel("models/hunter/blocks/cube075x075x025.mdl")
		self.collision:SetPos(self:GetPos() + Vector(-5, 0, 12))
		self.collision:SetParent(self)
		self.collision:SetNoDraw(true)
		self.collision:SetAngles(self:GetAngles() + Angle(90, 0, 0))
		self.collision:Spawn()

		print(self.collision)
		*/
	end

	self:DrawShadow(false)
	/*

	if CLIENT then
		local matrix = Matrix()
		matrix:Scale(Vector(0.4, 0.5, 0.5))
		self:EnableMatrix("RenderMultiply", matrix)
	end
	*/
	

end

function ENT:Use(activator, caller, useType, value)
	local ply = activator
	print(self.buildingName)
	local nicerApts = table.Copy(ix.apartments.list[self.buildingName])

	for k, apt in ipairs(nicerApts) do
		apt.niceNames = {}
		for index, CID in ipairs(apt) do
			apt.niceNames[index] = ix.char.GetByCID(CID):GetName()
			nicerApts[k] = ix.char.GetByCID(v.tenants)
		end
	end
	
	local apartments = util.Compress(util.TableToJSON(nicerApts))

	net.Start("prAptAction")
		net.WriteUInt(APTACT_OPEN, 32)
		net.WriteUInt(#apartments, 32)
		net.WriteData(apartments)
	net.Send(ply)
end

if CLIENT then
	local screenMat = Material("dev/dev_prisontvoverlay002")

	function ENT:Draw(flags)
		self:DrawModel()
		local scale = 50

		local scrW, scrH = 16.5*scale, 22.7*scale

		local localOffset = Vector(9.5, 8.25, 24.25)
		local realOffset = self:GetForward()*localOffset.x + self:GetRight()*localOffset.y + self:GetUp() * localOffset.z
		cam.Start3D2D(self:GetPos() + realOffset, Angle(180, 0 + self:GetAngles().y - 90, -90), 1/scale)

			surface.SetDrawColor(0, 0, 0)
			surface.DrawRect(0, 0, scrW, scrH)
			surface.SetMaterial(screenMat)
			surface.SetDrawColor(255, 255, 255)
			surface.DrawTexturedRect(0, 0, scrW, scrH)
			draw.SimpleText("AWAITING SIGN IN", "DermaDefault", 200, 500)

			draw.SimpleText()
		cam.End3D2D()
	end
end