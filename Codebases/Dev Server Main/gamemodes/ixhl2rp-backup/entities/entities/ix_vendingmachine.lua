
AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Vending Machine"
ENT.Category = "HL2 RP"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.PhysgunDisable = true
ENT.bNoPersist = true

ENT.MaxRenderDistance = math.pow(256, 2)
ENT.MaxStock = 4
ENT.Items = {
	{"REGULAR", "water", 5},
	{"FLAVORED", "water_flavored", 7},
	{"SPARKLING", "water_sparkling", 10},
	{"CHIPS", "uuchips", 5},
	{"FILTER", "citizenfilter", 10}
}

function ENT:GetStock(id)
	return self:GetNetVar("stock", {})[id] or self.MaxStock
end

function ENT:GetAllStock()
	return self:GetNetVar("stock", {})
end

if (SERVER) then
	function ENT:Initialize()
		self:SetModel("models/props_interiors/vendingmachinesoda01a.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)

		local physics = self:GetPhysicsObject()
		physics:EnableMotion(false)
		physics:Sleep()

		self.nextUseTime = 0
		self:SetNetVar("stock", {})
	end

	function ENT:SpawnFunction(client, trace)
		local vendor = ents.Create("ix_vendingmachine")

		vendor:SetPos(trace.HitPos + Vector(0, 0, 48))
		vendor:SetAngles(Angle(0, (vendor:GetPos() - client:GetPos()):Angle().y - 180, 0))
		vendor:Spawn()
		vendor:Activate()

		Schema:SaveVendingMachines()
		return vendor
	end

	function ENT:GetClosestButton(client)
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96
			data.filter = client
		local trace = util.TraceLine(data)
		local tracePosition = trace.HitPos

		if (tracePosition) then
			for k, v in ipairs(self.Items) do
				local position = self:GetPos() + self:GetForward() * 17.5 + self:GetRight() * -24.4 + (self:GetUp() * 5.3 - Vector(0, 0, (k - 1) * 2.1))

				if (position:DistToSqr(tracePosition) <= 1) then
					return k
				end
			end
		end
	end

	function ENT:SetStock(id, amount)
		if (type(id) == "table") then
			self:SetNetVar("stock", id)
			return
		end

		local stock = self:GetNetVar("stock", {})
		stock[id] = math.Clamp(amount, 0, self.MaxStock)

		self:SetNetVar("stock", stock)
	end

	function ENT:ResetStock(id)
		local stock = self:GetNetVar("stock", {})

		-- reset stock of all items if no id is specified
		if (id) then
			stock[id] = self.MaxStock
		else
			for k, v in ipairs(self.Items) do
				stock[k] = self.MaxStock
			end
		end

		self:SetNetVar("stock", stock)
	end

	function ENT:RemoveStock(id)
		self:SetStock(id, self:GetStock(id) - 1)
	end

	function ENT:Use(client)
		local buttonID = self:GetClosestButton(client)

		if (buttonID) then
			client:EmitSound("buttons/lightswitch2.wav", 40, 150)
		else
			return
		end

		if (self.nextUseTime > CurTime()) then
			return
		end

		local character = client:GetCharacter()


		local itemInfo = self.Items[buttonID]
		local price = itemInfo[3]

		if (!character:HasMoney(price)) then
			self:EmitSound("buttons/button2.wav", 50)
			self.nextUseTime = CurTime() + 1

			client:Notify(string.format("You need %d tokens to purchase this.", price))
			return false
		end

		if (self:GetStock(buttonID) > 0) then
			ix.item.Spawn(itemInfo[2], self:GetPos() + self:GetForward() * 19 + self:GetRight() * 4 + self:GetUp() * -26, function(item, entity)
				self:EmitSound("buttons/button4.wav", 60)

				character:TakeMoney(price)
				local itemTable = ix.item.list[itemInfo[2]]
				client:Notify("You have purchased "..itemTable.name.." for "..itemInfo[3].." tokens.")


				self:RemoveStock(buttonID)
				self.nextUseTime = CurTime() + 1
			end)
		else
			self:EmitSound("buttons/button2.wav", 50)
			self.nextUseTime = CurTime() + 1
		end
		end

	function ENT:OnRemove()
		if (!ix.shuttingDown) then
			Schema:SaveVendingMachines()
		end
	end
else
	surface.CreateFont("ixVendingMachine", {
		font = "Default",
		size = 13,
		weight = 800,
		antialias = false
	})

	local glowSprite = Material("sprites/light_glow02_add")
	local color_red = Color(100, 20, 20, 255)
	local color_blue = Color(0, 50, 100, 255)
	local color_black = Color(60, 60, 60, 255)
	local color_disabled = Color(30, 30, 30, 255)
	local color_green = Color(0, 255, 0, 255)
	local color_orange = Color(255, 125, 0, 255)

	function ENT:Draw()
		self:DrawModel()

		local position = self:GetPos()

		if (LocalPlayer():GetPos():DistToSqr(position) > self.MaxRenderDistance) then
			return
		end

		local angles = self:GetAngles()
		local forward, right, up = self:GetForward(), self:GetRight(), self:GetUp()

		angles:RotateAroundAxis(angles:Up(), 90)
		angles:RotateAroundAxis(angles:Forward(), 90)

		cam.Start3D2D(position + forward * 17.33 + right * -18.2 + up * 6.35, angles, 0.06)
			render.PushFilterMin(TEXFILTER.NONE)
			render.PushFilterMag(TEXFILTER.NONE)

			local width = 95
			local smallWidth = 20
			local height = 30
			local halfWidth = width / 2
			local halfHeight = height / 2

			for i = 1, 8 do
				local itemInfo = self.Items[i]
				local x = 0
				local y = (i - 1) * 35

				surface.SetDrawColor(0, 0, 0, 255)
				if i != 8 then
					surface.DrawRect(x, y, width + 6 + smallWidth + 10, height + 5)
				else
					surface.DrawRect(x, y, width + 6 + smallWidth + 10, height)
				end

				


				if (itemInfo) then
					surface.SetDrawColor(color_black)
					surface.DrawOutlinedRect(x, y, width, height)

					surface.SetDrawColor(color_black)
					surface.DrawRect(x + 1, y + 1, width - 2, height - 2)

					draw.SimpleText(itemInfo[1].." ("..itemInfo[3]..")", "ixVendingMachine", x + halfWidth, y + halfHeight, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				else
					surface.SetDrawColor(color_disabled)
					surface.DrawOutlinedRect(x, y, width, height)

					surface.SetDrawColor(color_disabled)
					surface.DrawRect(x + 1, y + 1, width - 2, height - 2)
				end
			end

			render.PopFilterMin()
			render.PopFilterMag()
		cam.End3D2D()
		render.SetMaterial(glowSprite)
		for i = 8, 1, -1 do
			local width = 95
			local smallWidth = 20
			local height = 30
			local halfWidth = width / 2
			local halfHeight = height / 2
			
			local itemInfo = self.Items[i]
			local x = 0
			local y = 280 - (i - 8) * 35
			local color

			local pos = position + forward * 17.75 + right * -31.54 + up * -26.91 + (x + width + 6 + smallWidth/2)*0.06*right + (y + height/2)*0.06*up
			
			if (itemInfo) then
				if self:GetStock(i) > 0 then
					color = color_green
				else
					color = color_orange
				end

				
			else
				color = color_orange
			end
			
			render.DrawSprite(pos, 3, 3, color)
		end
	end
end
