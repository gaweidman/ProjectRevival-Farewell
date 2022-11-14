
AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Decontamination Chamber"
ENT.Category = "HL2 RP"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.PhysgunDisable = true
ENT.bNoPersist = true

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "ID")
end

if SERVER then

	function ENT:Initialize()
		
		self:SetModel("models/props_wasteland/laundry_washer001a.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)

		ix.inventory.New(0, "decontamChamber", function(inventory)
			-- we'll technically call this a bag since we don't want other bags to go inside
			inventory.vars.isBag = true
			inventory.vars.isContainer = true

			if (IsValid(self)) then
				self:SetInventory(inventory)
			end
		end) 
	end

	function ENT:SetInventory(inventory)
		if (inventory) then
			self:SetID(inventory:GetID())
		end
	end

	function ENT:OpenInventory(activator)
		local inventory = self:GetInventory()

		if (inventory) then
			ix.storage.Open(activator, inventory, {
				name = "Decontamination Chamber",
				entity = self,
				searchTime = ix.config.Get("containerOpenTime", 0.7),
				data = {},
				OnPlayerClose = function()
					ix.log.Add(activator, "closeContainer", name, inventory:GetID())
				end
			})

			ix.log.Add(activator, "openContainer", name, inventory:GetID())
		end
	end

	function ENT:Use(activator)
		local inventory = self:GetInventory()

		if (inventory and (activator.ixNextOpen or 0) < CurTime()) then
			local character = activator:GetCharacter()

			if (character) then
				self:OpenInventory(activator)
			end

			activator.ixNextOpen = CurTime() + 1
		end
	end
end

if CLIENT then
	ENT.PopulateEntityInfo = true

	function ENT:OnPopulateEntityInfo(tooltip)
		local title = tooltip:AddRow("name")
		title:SetImportant()
		title:SetText("Decontamination Chamber")
		title:SetBackgroundColor(ix.config.Get("color"))
		title:SizeToContents()

		local description = tooltip:AddRow("description")
		description:SetText("A large chamber meant to clean things of microscopic organisms.")
		description:SizeToContents()
	end
end

function ENT:GetInventory()
	return ix.item.inventories[self:GetID()]
end