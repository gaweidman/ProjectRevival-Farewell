
ENT.Type = "anim"
ENT.PrintName = "Container"
ENT.Category = "Helix"
ENT.Spawnable = false
ENT.bNoPersist = true

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "ID")
	self:NetworkVar("Bool", 0, "Locked")
	self:NetworkVar("String", 0, "DisplayName")
	self:NetworkVar("Bool", 1, "CombineLocked")
	self:NetworkVar("Bool", 2, "CWULocked")
end

if (SERVER) then
	function ENT:Initialize()
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self.receivers = {}

		local definition = ix.container.stored[self:GetModel():lower()]

		if (definition) then
			self:SetDisplayName(definition.name)
		end

		local physObj = self:GetPhysicsObject()

		if (IsValid(physObj)) then
			physObj:EnableMotion(true)
			physObj:Wake()
		end
	end

	function ENT:SetInventory(inventory)
		if (inventory) then
			self:SetID(inventory:GetID())
		end
	end

	function ENT:SetMoney(amount)
		self.money = math.max(0, math.Round(tonumber(amount) or 0))
	end

	function ENT:GetMoney()
		return self.money or 0
	end

	function ENT:OnRemove()
		local index = self:GetID()

		if (!ix.shuttingDown and !self.ixIsSafe and ix.entityDataLoaded and index) then
			local inventory = ix.item.inventories[index]

			if (inventory) then
				ix.item.inventories[index] = nil

				local query = mysql:Delete("ix_items")
					query:Where("inventory_id", index)
				query:Execute()

				query = mysql:Delete("ix_inventories")
					query:Where("inventory_id", index)
				query:Execute()

				hook.Run("ContainerRemoved", self, inventory)
			end
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

				if self:GetCombineLocked() then
					if character:IsCombine() then
						self:OpenInventory(activator)
					else
						self:EmitSound("buttons/combine_button_locked.wav")
						activator:Notify("This container is Combine locked!")
					end
				elseif self:GetCWULocked() then
					if character:IsCombine() or character:GetInventory():HasItem("uid") != false then
						self:OpenInventory(activator)
					else
						self:EmitSound("buttons/combine_button_locked.wav")
						activator:Notify("This container is CWU locked!")
					end
				elseif (self:GetLocked() and !self.Sessions[character:GetID()]) then
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

	function ENT:SetCombineRet(locked)
		self.cmbLocked = locked
	end

	function ENT:GetCombineRet()
		return self.cmbLocked or false
	end

	function ENT:SetCWURet(locked)
		self.cwuLocked = locked
	end

	function ENT:GetCWURet()
		return self.cwuLocked or false
	end

	
else
	ENT.PopulateEntityInfo = true
	util.PrecacheModel("models/props_combine/combine_lock01.mdl")

	local COLOR_LOCKED = Color(255, 143, 143, 200)
	local COLOR_UNLOCKED = Color(135, 211, 124, 200)
	local COLOR_CMBLOCKED = Color(255, 150, 0, 200)
	local COLOR_CMBUNLOCKED = Color(255, 150, 0, 200)
	local COLOR_CWULOCKED = Color(82, 162, 241, 200)

	local glowMaterial = ix.util.GetMaterial("sprites/glow04_noz")
	local color_cmbglow = Color(255, 125, 0, 255)
	local color_cwuglow = Color(0, 100, 255, 255)

	function ENT:OnPopulateEntityInfo(tooltip)
		local definition = ix.container.stored[self:GetModel():lower()]
		local bLocked = self:GetLocked()
		local cmbLocked = self:GetCombineLocked()
		local teamLocked = cmbLocked or self:GetCWULocked()

		local font = "ixIconsSmall"
		if teamLocked then
			font = "ixPRIconsTooltip"
		else
			font = "ixIconsSmall"
		end

		surface.SetFont(font)

		local iconText
		local textColor

		if bLocked then 
			iconText = "P"
			textColor = COLOR_LOCKED
		elseif teamLocked then
			iconText = "m"
			if cmbLocked then
				textColor = COLOR_CMBLOCKED
			else
				textColor = COLOR_CWULOCKED
			end
		else 
			iconText = "Q" 
			textColor = COLOR_UNLOCKED
		end

		local iconWidth, iconHeight = surface.GetTextSize(iconText)

		-- minimal tooltips have centered text so we'll draw the icon above the name instead
		if (tooltip:IsMinimal()) then
			local icon = tooltip:AddRow("icon")
			icon:SetFont(font)
			icon:SetTextColor(textColor)
			icon:SetText(iconText)
			icon:SizeToContents()
		end

		local title = tooltip:AddRow("name")
		title:SetImportant()
		title:SetText(self:GetDisplayName())
		title:SetBackgroundColor(ix.config.Get("color"))
		title:SetTextInset(iconWidth + 8, 0)
		title:SizeToContents()

		if (!tooltip:IsMinimal()) then
			title.Paint = function(panel, width, height)
				panel:PaintBackground(width, height)

				surface.SetFont(font)
				surface.SetTextColor(textColor)
				surface.SetTextPos(4, height * 0.5 - iconHeight * 0.5)
				surface.DrawText(iconText)
			end
		end

		local description = tooltip:AddRow("description")
		description:SetText(definition.description)
		description:SizeToContents()
	end

	function ENT:Draw()
		self:DrawModel()
		local cmbLocked = self:GetCombineLocked()
		local cwuLocked = self:GetCWULocked()

		local teamLocked = cmbLocked or cwuLocked
		local locked = self:GetLocked()

		local color

		local lockValid = IsValid(self.lockModel)

		if cmbLocked then color = color_cmbglow
		elseif cwuLocked then color = color_cwuglow end

		print("teamLocked", teamLocked)

		if teamLocked and !lockValid then
			print("Trying to make a new lockModel")
			self.lockModel = ClientsideModel("models/props_combine/combine_lock01.mdl")
			local lowBounds, highBounds = self:GetRenderBounds()
			local boundDiff = (highBounds - lowBounds)/2
	
			local forward = self:GetForward()
			local angles = self:GetAngles()
	
			self.lockModel:SetPos(self:GetPos() + (boundDiff.x)*forward + self:GetRight()*1.5 + forward*1)
	
			self.lockModel:SetAngles(Angle(0, angles.y - 90, 0))
			self.lockModel:SetParent(self)
			self.lockModel:SetModelScale(0.75)
			self.lockModel:SetNoDraw(true)
			lockValid = true
		elseif locked and !lockValid then
			self.lockModel = ClientsideModel("models/props_wasteland/prison_padlock001a.mdl")
			local lowBounds, highBounds = self:GetRenderBounds()
			local boundDiff = (highBounds - lowBounds)/2
	
			local forward = self:GetForward()
			local angles = self:GetAngles()
	
			self.lockModel:SetPos(self:GetPos() + (boundDiff.x)*forward)
	
			self.lockModel:SetAngles(Angle(0, angles.y, 0))
			self.lockModel:SetParent(self)
			self.lockModel:SetModelScale(1)
			self.lockModel:SetNoDraw(true)
			lockValid = true
		elseif !teamLocked and lockValid and self.lockModel:GetModel() == "models/props_combine/combine_lock01.mdl" then
			print("removing")
			self.lockModel:Remove()
		elseif teamLocked and lockValid and self.lockModel:GetModel() != "models/props_combine/combine_lock01.mdl" then
			self.lockModel:Remove()
		end

		if lockValid then
			self.lockModel:DrawModel()
			if teamLocked then
				local position = self.lockModel:GetPos() + self.lockModel:GetUp() * -8.7*0.75 + self.lockModel:GetForward() * -3.85*0.75 + self.lockModel:GetRight() * -6*0.75
				render.SetMaterial(glowMaterial)
				render.DrawSprite(position, 5, 5, color)
			end
		end
	end

	function ENT:OnRemove()
		if self.lockModel then self.lockModel:Remove() end
	end
end

function ENT:GetInventory()
	return ix.item.inventories[self:GetID()]
end
