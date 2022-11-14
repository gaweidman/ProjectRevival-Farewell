
local gradient = ix.util.GetMaterial("vgui/gradient-u")
local gradient2 = ix.util.GetMaterial("vgui/gradient-d")

local PANEL = {}

AccessorFunc(PANEL, "color", "Color")
AccessorFunc(PANEL, "value", "Value", FORCE_NUMBER)
AccessorFunc(PANEL, "boostValue", "Boost", FORCE_NUMBER)
AccessorFunc(PANEL, "max", "Max", FORCE_NUMBER)

function PANEL:Init()
	self:SetTall(64)

	local wholePanel = self

	local arrowSize = 32
	local margin = arrowSize/2

	self.add = self:Add("DPanel")
	self.add:SetSize(arrowSize, arrowSize)
	self.add:Dock(RIGHT)
	self.add:DockMargin(2, margin, 2, margin)
	self.add.OnMousePressed = function()
		self.pressing = 1
		self:DoChange()
		self.add:SetAlpha(150)
	end
	self.add.OnMouseReleased = function()
		if (self.pressing) then
			self.pressing = nil
			self.add:SetAlpha(255)
		end
	end

	self.add.Paint = function(panel, w, h)
		local schemeColor = ix.config.Get("color")
		surface.SetDrawColor(schemeColor)
		draw.NoTexture()
		surface.DrawPoly({
			{x = 0, y = 0}, {x = w, y = h/2}, {x = 0, y = h}
		})
	end

	self.add.OnCursorExited = self.add.OnMouseReleased

	self.numPnl = self:Add("DPanel")
	self.numPnl:SetSize(64, 64)
	self.numPnl:Dock(RIGHT)
	self.numPnl:SetContentAlignment(5)
	self.numPnl:DockMargin(2, 2, 2, 2)

	self.numPnl.Paint = function(panel, w, h)
		local schemeColor = ix.config.Get("color")
		local fontHeight = draw.GetFontHeight("ixMenuButtonFontThick")
		draw.DrawText(tostring(wholePanel:GetValue()), "ixMenuButtonFontThick", w/2, h/2 - fontHeight/2, schemeColor, TEXT_ALIGN_CENTER)
	end

	self.sub = self:Add("DPanel")
	self.sub:SetSize(arrowSize, arrowSize)
	self.sub:Dock(RIGHT)
	self.sub:DockMargin(2, margin, 2, margin)
	self.sub.OnMousePressed = function()
		self.pressing = -1
		self:DoChange()
		self.sub:SetAlpha(150)
	end
	self.sub.OnMouseReleased = function()
		if (self.pressing) then
			self.pressing = nil
			self.sub:SetAlpha(255)
		end
	end
	
	self.sub.Paint = function(panel, w, h)
		local schemeColor = ix.config.Get("color")
		surface.SetDrawColor(schemeColor)
		draw.NoTexture()
		surface.DrawPoly({
			{x = 0, y = h/2}, {x = w, y = 0}, {x = w, y = h}
		})
	end

	self.sub.OnCursorExited = self.sub.OnMouseReleased

	self.value = 0
	self.deltaValue = self.value
	self.max = 10

	self.bar = self:Add("DPanel")
	self.bar:Dock(FILL)
	self.bar.Paint = function(this, w, h)
		/*
		surface.SetDrawColor(35, 35, 35, 250)
		surface.DrawRect(0, 0, w, h)

		w, h = w - 4, h - 4

		local value = self.deltaValue / self.max

		if (value > 0) then
			local color = self.color and self.color or ix.config.Get("color")
			local boostedValue = self.boostValue or 0
			local add = 0

			if (self.deltaValue != self.value) then
				add = 35
			end

			-- your stat
			do
				if !(boostedValue < 0 and math.abs(boostedValue) > self.value) then
					surface.SetDrawColor(color.r + add, color.g + add, color.b + add, 230)
					surface.DrawRect(2, 2, w * value, h)

					surface.SetDrawColor(255, 255, 255, 35)
					surface.SetMaterial(gradient)
					surface.DrawTexturedRect(2, 2, w * value, h)
				end
			end

			-- boosted stat
			do
				local boostValue

				if (boostedValue != 0) then
					if (boostedValue < 0) then
						local please = math.min(self.value, math.abs(boostedValue))
						boostValue = ((please or 0) / self.max) * (self.deltaValue / self.value)
					else
						boostValue = ((boostedValue or 0) / self.max) * (self.deltaValue / self.value)
					end

					if (boostedValue < 0) then
						surface.SetDrawColor(200, 40, 40, 230)

						local bWidth = math.abs(w * boostValue)
						surface.DrawRect(2 + w * value - bWidth, 2, bWidth, h)

						surface.SetDrawColor(255, 255, 255, 35)
						surface.SetMaterial(gradient)
						surface.DrawTexturedRect(2 + w * value - bWidth, 2, bWidth, h)
					else
						surface.SetDrawColor(40, 200, 40, 230)
						surface.DrawRect(2 + w * value, 2, w * boostValue, h)

						surface.SetDrawColor(255, 255, 255, 35)
						surface.SetMaterial(gradient)
						surface.DrawTexturedRect(2 + w * value, 2, w * boostValue, h)
					end
				end
			end
		end

		surface.SetDrawColor(255, 255, 255, 5)
		surface.SetMaterial(gradient2)
		surface.DrawTexturedRect(2, 2, w, h)
		*/
	end

	self.label = self.bar:Add("DLabel")
	self.label:Dock(FILL)
	self.label:SetFont("ixMenuButtonLabelFont")
	self.label:SetExpensiveShadow(1, Color(0, 0, 60))
	self.label:SetContentAlignment(4)
end

function PANEL:Think()
	if (self.pressing) then
		if ((self.nextPress or 0) < CurTime()) then
			self:DoChange()
		end
	end

	self.deltaValue = math.Approach(self.deltaValue, self.value, FrameTime() * 15)
end

function PANEL:SetHelixTooltip(tooltipFunc)
	self.bar:SetHelixTooltip(tooltipFunc)
end

function PANEL:DoChange()
	if ((self.value == 1 and self.pressing == -1) or (self.value == self.max and self.pressing == 1)) then
		return
	end

	self.nextPress = CurTime() + 0.2

	if (self:OnChanged(self.pressing) != false) then
		self.value = math.Clamp(self.value + self.pressing, 0, self.max)
	end
end

function PANEL:OnChanged(difference)
end

function PANEL:SetText(text)
	self.label:SetText(text)
end

function PANEL:SetReadOnly()
	self.sub:Remove()
	self.add:Remove()
	self.numPnl:Remove()
	self.label:SetContentAlignment(5)
	self.label:SetFont("ixMenuButtonFont")
	--self.title:SetContentAlignment(5)
end

function PANEL:Paint(w, h)
	
end

vgui.Register("ixAttributeBar", PANEL, "DPanel")
