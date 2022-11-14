
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

			if (IsValid(container)) then
				container:SetInventory(inventory)
				self:SaveContainer()
			end
		end)
		
	end

	function ENT:Use(client, caller, useType)
		
	end

	function ENT:SetInventory(inventory)
		if (inventory) then
			self:SetID(inventory:GetID())
		end
	end

	function ENT:OpenInventory(activator)
		local inventory = self:GetInventory()

		if (inventory) then
			local name = self:GetDisplayName()

			ix.storage.Open(activator, inventory, {
				name = name,
				entity = self,
				searchTime = ix.config.Get("containerOpenTime", 0.7),
				data = {money = self:GetMoney()},
				OnPlayerClose = function()
					ix.log.Add(activator, "closeContainer", name, inventory:GetID())
				end
			})

			if (self:GetLocked()) then
				self.Sessions[activator:GetCharacter():GetID()] = true
			end

			ix.log.Add(activator, "openContainer", name, inventory:GetID())
		end
	end

	function ENT:Use(activator)
		local inventory = self:GetInventory()

		if (inventory and (activator.ixNextOpen or 0) < CurTime()) then
			local character = activator:GetCharacter()

			if (character) then
				local def = ix.container.stored[self:GetModel():lower()]

				if (self:GetLocked() and !self.Sessions[character:GetID()]) then
					self:EmitSound(def.locksound or "doors/default_locked.wav")

					if (!self.keypad) then
						net.Start("ixContainerPassword")
							net.WriteEntity(self)
						net.Send(activator)
					end
				else
					self:OpenInventory(activator)
				end
			end

			activator.ixNextOpen = CurTime() + 1
		end
	end
end

function ENT:GetInventory()
	return ix.item.inventories[self:GetID()]
end