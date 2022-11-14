local PANEL = {}
	function PANEL:Init()
		self:SetFont("nutMenuButtonFont")
		self:SetExpensiveShadow(2, Color(0, 0, 0, 200))
		self:SetTextColor(color_white)
		self:SetPaintBackground(true)
		self:SetDrawBackground(false)
		//self:SetDrawBackground(Color(0, 0, 255))
		self.OldSetTextColor = self.SetTextColor
		self.SetTextColor = function(this, color)
			this:OldSetTextColor(color)
			this:SetFGColor(color)
		end
	end

	function PANEL:Paint(w, h)
		local outlineSize = 1
		local shrinkFactor = outlineSize*2
		local bodyColor = Color( 105, 234, 255, 150 )
		draw.RoundedBox( 10, 0, 0, w, h, Color( 255, 255, 255, 150 ) ) // Main Box
		draw.RoundedBox( 10, shrinkFactor/2, shrinkFactor/2, w - shrinkFactor, h - shrinkFactor, bodyColor ) // Outline Box
	end

	function PANEL:setText(text, noTranslation)
		surface.SetFont("nutMenuButtonFont")

		self:SetText(noTranslation and text:upper() or L(text):upper())

		if (!noTranslation) then
			self:SetToolTip(L(text.."Tip"))
		end

		local w, h = surface.GetTextSize(self:GetText())
		self:SetSize(w + 64, h + 32)
	end

	function PANEL:OnCursorEntered()
		local color = self:GetTextColor()
		self:SetTextColor(Color(math.max(color.r - 25, 0), math.max(color.g - 25, 0), math.max(color.b - 25, 0)))

		surface.PlaySound("ui/buttonrollover.wav")
	end

	function PANEL:OnCursorExited()
		if (self.color) then
			self:SetTextColor(self.color)
		else
			self:SetTextColor(color_white)
		end
	end

	function PANEL:OnMousePressed(code)
		if (self.color) then
			self:SetTextColor(self.color)
		else
			self:SetTextColor(nut.config.get("color"))
		end

		surface.PlaySound("ui/buttonclickrelease.wav")

		if (code == MOUSE_LEFT and self.DoClick) then
			self:DoClick(self)
		end
	end

	function PANEL:OnMouseReleased(key)
		if (self.color) then
			self:SetTextColor(self.color)
		else
			self:SetTextColor(color_white)
		end
	end
vgui.Register("nutMenuButton", PANEL, "DButton")

local PANEL = {}
	function PANEL:Init()
		self:SetFont("nutMenuButtonFont")
		self:SetExpensiveShadow(2, Color(0, 0, 0, 200))
		self:SetTextColor(color_white)
		self:SetPaintBackground(true)
		self:SetDrawBackground(false)
		//self:SetDrawBackground(Color(0, 0, 255))
		self.OldSetTextColor = self.SetTextColor
		self.SetTextColor = function(this, color)
			this:OldSetTextColor(color)
			this:SetFGColor(color)
		end
	end

	function PANEL:Paint(w, h)
		local outlineSize = 1
		local shrinkFactor = outlineSize*2
		local bodyColor = Color( 105, 234, 255, 150 )
		draw.RoundedBox( 10, 0, 0, w, h, Color( 255, 255, 255, 150 ) ) // Main Box
		draw.RoundedBox( 10, shrinkFactor/2, shrinkFactor/2, w - shrinkFactor, h - shrinkFactor, bodyColor ) // Outline Box
	end

	function PANEL:setText(text, noTranslation)
		surface.SetFont("nutMenuButtonFont")

		self:SetText(noTranslation and text:upper() or L(text):upper())

		if (!noTranslation) then
			self:SetToolTip(L(text.."Tip"))
		end

		local w, h = surface.GetTextSize(self:GetText())
		self:SetSize(w + 64, h + 32)
	end

	function PANEL:OnCursorEntered()
		local color = self:GetTextColor()
		self:SetTextColor(Color(math.max(color.r - 25, 0), math.max(color.g - 25, 0), math.max(color.b - 25, 0)))

		surface.PlaySound("ui/buttonrollover.wav")
	end

	function PANEL:OnCursorExited()
		if (self.color) then
			self:SetTextColor(self.color)
		else
			self:SetTextColor(color_white)
		end
	end

	function PANEL:OnMousePressed(code)
		if (self.color) then
			self:SetTextColor(self.color)
		else
			self:SetTextColor(nut.config.get("color"))
		end

		surface.PlaySound("ui/buttonclickrelease.wav")

		if (code == MOUSE_LEFT and self.DoClick) then
			self:DoClick(self)
		end
	end

	function PANEL:OnMouseReleased(key)
		if (self.color) then
			self:SetTextColor(self.color)
		else
			self:SetTextColor(color_white)
		end
	end
vgui.Register("nutMenuButtonNoBG", PANEL, "DButton")