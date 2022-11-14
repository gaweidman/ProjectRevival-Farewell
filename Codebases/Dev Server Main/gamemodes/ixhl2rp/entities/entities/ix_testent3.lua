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

ENT.PrintName = "Citizen Terminal"
ENT.Author    = "Lexi"
ENT.Spawnable = true
ENT.Category  = "Dev Stuff"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT


function ENT:Initialize()

	self:SetModel( "models/props/vidphone01a.mdl" )
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
	net.Start("prCivTerminal")
		net.WriteUInt(1, 32)
	net.Send(activator)
end