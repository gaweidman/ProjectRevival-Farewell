
AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Air Vent"
ENT.Category = "HL2 RP"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.PhysgunDisable = true
ENT.bNoPersist = true


if (SERVER) then
	function ENT:Initialize()
		self:SetModel("models/props_combine/combine_emitter01.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
	end	
end

if (CLIENT) then
	ENT.PopulateEntityInfo = true

	function ENT:OnPopulateEntityInfo(tooltip)
		local name = tooltip:AddRow("name")
		name:SetImportant()
		name:SetText("Combine Air Vent")
		name:SizeToContents()

		local description = tooltip:AddRow("description")
		description:SetText("A device constantly pumping out fresh O₂, installed by the Combine.")
		description:SizeToContents()
	end
end