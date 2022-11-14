
local DEFAULT_PADDING = ScreenScale(32)
local DEFAULT_ANIMATION_TIME = 1
local DEFAULT_SUBPANEL_ANIMATION_TIME = 0.5
local animationTime = 0.5

-- parent subpanel
local PANEL = {}

function PANEL:Init()
	local parent = self:GetParent()
	local padding = parent.GetPadding and parent:GetPadding() or DEFAULT_PADDING

	self:SetSize(parent:GetWide() - (padding * 2), parent:GetTall() - (padding * 2))
	self:Center()
end

function PANEL:SetTitle(text, bNoTranslation, bNoUpper)
	if (text == nil) then
		if (IsValid(self.title)) then
			self.title:Remove()
		end

		return
	elseif (!IsValid(self.title)) then
		self.title = self:Add("DLabel")
		self.title:SetFont("ixTitleFont")
		self.title:SizeToContents()
		self.title:SetTextColor(ix.config.Get("color") or color_white)
		self.title:Dock(TOP)
	end

	local newText = bNoTranslation and text or L(text)
	newText = bNoUpper and newText or newText:utf8upper()

	self.title:SetText(newText)
	self.title:SizeToContents()
end

function PANEL:SetLeftPanel(panel)
	self.left = panel
end

function PANEL:GetLeftPanel()
	return self.left
end

function PANEL:SetRightPanel(panel)
	self.right = panel
end

function PANEL:GetRightPanel()
	return self.right
end

function PANEL:OnSetActive()
end

function PANEL:Think()
end

vgui.Register("ixSubpanel", PANEL, "EditablePanel")

-- subpanel parent
DEFINE_BASECLASS("EditablePanel")
PANEL = {}

AccessorFunc(PANEL, "padding", "Padding", FORCE_NUMBER)
AccessorFunc(PANEL, "animationTime", "AnimationTime", FORCE_NUMBER)
AccessorFunc(PANEL, "subpanelAnimationTime", "SubpanelAnimationTime", FORCE_NUMBER)
AccessorFunc(PANEL, "leftOffset", "LeftOffset", FORCE_NUMBER)

function PANEL:Init()
	self.subpanels = {}
	self.childPanels = {}

	self.currentSubpanelX = DEFAULT_PADDING
	self.targetSubpanelX = DEFAULT_PADDING
	self.padding = DEFAULT_PADDING
	self.leftOffset = 0

	self.animationTime = DEFAULT_ANIMATION_TIME
	self.subpanelAnimationTime = DEFAULT_SUBPANEL_ANIMATION_TIME
end

function PANEL:SetPadding(amount, bSetDockPadding)
	self.currentSubpanelX = amount
	self.targetSubpanelX = amount
	self.padding = amount

	if (bSetDockPadding) then
		self:DockPadding(amount, amount, amount, amount)
	end
end

function PANEL:Add(name)
	local panel = BaseClass.Add(self, name)

	if (panel.SetPaintedManually) then
		panel:SetPaintedManually(true)
		self.childPanels[#self.childPanels + 1] = panel
	end

	return panel
end

function PANEL:AddSubpanel(name)
	local id = #self.subpanels + 1
	local panel = BaseClass.Add(self, "ixSubpanel")
	panel.subpanelName = name
	panel.subpanelID = id
	panel:SetTitle("Test")

	self.subpanels[id] = panel
	self:SetupSubpanelReferences()

	return panel
end

function PANEL:SetupSubpanelReferences()
	local lastPanel

	for i = 1, #self.subpanels do
		local panel = self.subpanels[i]
		local nextPanel = self.subpanels[i + 1]

		if (IsValid(lastPanel)) then
			lastPanel:SetRightPanel(panel)
			panel:SetLeftPanel(lastPanel)
		end

		if (IsValid(nextPanel)) then
			panel:SetRightPanel(nextPanel)
		end

		lastPanel = panel
	end
end

function PANEL:SetSubpanelPos(id, x)
	local currentPanel = self.subpanels[id]

	if (!currentPanel) then
		return
	end

	local _, oldY = currentPanel:GetPos()
	currentPanel:SetPos(x, oldY)

	-- traverse left
	while (IsValid(currentPanel)) do
		local left = currentPanel:GetLeftPanel()

		if (IsValid(left)) then
			left:MoveLeftOf(currentPanel, self.padding + self.leftOffset)
		end

		currentPanel = left
	end

	currentPanel = self.subpanels[id]

	-- traverse right
	while (IsValid(currentPanel)) do
		local right = currentPanel:GetRightPanel()

		if (IsValid(right)) then
			right:MoveRightOf(currentPanel, self.padding)
		end

		currentPanel = right
	end
end

function PANEL:SetActiveSubpanel(id, length)
	if (isstring(id)) then
		for i = 1, #self.subpanels do
			if (self.subpanels[i].subpanelName == id) then
				id = i
				break
			end
		end
	end

	local activePanel = self.subpanels[id]

	if (!activePanel) then
		return false
	end

	if (length == 0 or !self.activeSubpanel) then
		self:SetSubpanelPos(id, self.padding + self.leftOffset)
	else
		local x, _ = activePanel:GetPos()
		local target = self.targetSubpanelX + self.leftOffset
		self.currentSubpanelX = x + self.padding + self.leftOffset

		self:CreateAnimation(length or self.subpanelAnimationTime, {
			index = 420,
			target = {currentSubpanelX = target},
			easing = "outQuint",

			Think = function(animation, panel)
				panel:SetSubpanelPos(id, panel.currentSubpanelX)
			end,

			OnComplete = function(animation, panel)
				panel:SetSubpanelPos(id, target)
			end
		})
	end

	self.activeSubpanel = id
	activePanel:OnSetActive()

	return true
end

function PANEL:GetSubpanel(id)
	return self.subpanels[id]
end

function PANEL:GetActiveSubpanel()
	return self.subpanels[self.activeSubpanel]
end

function PANEL:GetActiveSubpanelID()
	return self.activeSubpanel
end

function PANEL:Slide(direction, length, callback, bIgnoreConfig)
	local _, height = self:GetParent():GetSize()
	local x, _ = self:GetPos()
	local targetY = direction == "up" and 0 or height

	self:SetVisible(true)

	if (length == 0) then
		self:SetPos(x, targetY)
	else
		length = length or self.animationTime
		self.currentY = direction == "up" and height or 0

		self:CreateAnimation(length or self.animationTime, {
			index = -1,
			target = {currentY = targetY},
			easing = "outExpo",
			bIgnoreConfig = bIgnoreConfig,

			Think = function(animation, panel)
				local currentX, _ = panel:GetPos()

				panel:SetPos(currentX, panel.currentY)
			end,

			OnComplete = function(animation, panel)
				if (direction == "down") then
					panel:SetVisible(false)
				end

				if (callback) then
					callback(panel)
				end
			end
		})
	end
end

function PANEL:SlideUp(...)
	self:SetMouseInputEnabled(true)
	self:SetKeyboardInputEnabled(true)

	self:OnSlideUp()
	self:Slide("up", ...)
end

function PANEL:SlideDown(...)
	self:SetMouseInputEnabled(false)
	self:SetKeyboardInputEnabled(false)

	self:OnSlideDown()
	self:Slide("down", ...)
end

function PANEL:OnSlideUp()
end

function PANEL:OnSlideDown()
end

function PANEL:Paint(width, height)
	for i = 1, #self.childPanels do
		self.childPanels[i]:PaintManual()
	end
end

function PANEL:PaintSubpanels(width, height)
	for i = 1, #self.subpanels do
		self.subpanels[i]:PaintManual()
	end
end

-- ????
PANEL.Remove = BaseClass.Remove

vgui.Register("ixSubpanelParent", PANEL, "EditablePanel")

-- This stuff here actually works, unlike some helixes I can mention.

--[ Enum Definitions ]--

-- These are for setting the animation type on the prMenuParent.
ANIM_FADE = 1 -- A fade between the two panels.
ANIM_SLIDEL = 2 -- A slide to the left from one panel to another.
ANIM_SLIDET = 3 -- A slide to the top from one panel to another.
ANIM_SLIDER = 4 -- A slide to the right from one panel to another.
ANIM_SLIDEB = 5 -- A slide to the bottom from one panel to another.

--[ Structs ]--

--- PRSUBPANEL
-- This is the format for prMenuParent's subpanels. A table using this struct is passed into prMenuBase:AddSubpanel()
-- @string displayName The name shown on the navbar's button.
-- @string icon The icon shown on the navbar's button, taken from the pr-icons font.
-- @func populate The function to populate the subpanel.
-- @func postPopulate A function run after the subpanel has been populated.

DEFINE_BASECLASS("EditablePanel")
PANEL = {}

AccessorFunc(PANEL, "padding", "Padding", FORCE_NUMBER)
AccessorFunc(PANEL, "animationTime", "AnimationTime", FORCE_NUMBER)
AccessorFunc(PANEL, "subpanelAnimationTime", "SubpanelAnimationTime", FORCE_NUMBER)
AccessorFunc(PANEL, "navbarDock", "NavbarDock", FORCE_NUMBER)
AccessorFunc(PANEL, "activeSubpanel", "ActiveSubpanel", FORCE_STRING)


-- This name is a little ambiguous and may make it a little confusing.
-- This is the size of the bar in the dimension of its dock direction. 

-- In other words, if the button bar is docked to the top or bottom, this sets the
-- bar's height. If the bar is docked to the left or right, this sets the bar's width.
AccessorFunc(PANEL, "navbarSize", "NavbarSize", FORCE_NUMBER)

function PANEL:Init()
	self:SetPos(0, 0)
	self:SetSize(ScrW(), ScrH())

	-- This stops the user from unfocusing the menu by clicking outside of it.
	self.borderGuard = self:Add("Panel")
	self.borderGuard:SetPos(0, 0)
	self.borderGuard:SetSize(ScrW(), ScrH())
	self.borderGuard:SetZPos(-999)

	-- This is where the actual "menu" part of the menu is.
	-- In other words, this is the container for the actual content.
	self.displayWindow = self:Add("EditablePanel")

	-- This is the table of panels that are displayed inside the display window.
	-- The indexes are the ids referred to in the function parameters below.
	self.subpanels = {}

	-- This is where the buttons to navigate between subpanels go.
	self.navbar = self:Add("Panel")

	self.navbar:DockPadding(5, 5, 5, 5)

	self.paddingL = 0
	self.paddingT = 0
	self.paddingR = 0
	self.paddingB = 0

	self.navbarSize = 30

	self:SetMouseInputEnabled(true)
	self:MakePopup()
end

--- Sets the menu's distance from the screen's borders.
-- @realm client
-- @number leftMargin Distance from the screen's left border.
-- @number topMargin Distance from the screen's top border.
-- @number rightMargin Distance from the screen's right border.
-- @number bottomMargin Distance from the screen's bottom border.
function PANEL:SetMargin(left, top, right, bottom)
	self.displayWindow:SetSize(ScrW() - left - right, ScrH() - top - bottom)
	self.displayWindow:SetPos(left, top)

	self:DockPadding(left, top, right, bottom)

	self.paddingL = left
	self.paddingT = top
	self.paddingR = right
	self.paddingB = bottom
end

--- Sets where the navbar is docked to.
-- @realm client
-- @number dockType Dock type using Enums/DOCK.
function PANEL:SetNavbarDock(dock)
	self.navbarDock = dock

	self.navbar:Dock(dock)

	-- Because the navbar size works kind of weirdly, this makes sure the sizing is going in the right direciton.
	self:SetNavbarSize(self.navbarSize)

	self.navbar:SetZPos(1)
	self.displayWindow:SetZPos(2)

	self.displayWindow:Dock(dock)
end

function PANEL:GetNavBar()
	return self.navbar
end

--- Sets the size of the navbar. For more information, see the AccessorFunc() for navbarSize
-- @realm client
-- @number size The size of the navbar.
function PANEL:SetNavbarSize(size)
	self.navbarSize = size

	if self.navbarDock == TOP or navbarDock == BOTTOM then
		self.navbar:SetSize(ScrW() - self.paddingL - self.paddingR, size)
		self.displayWindow:SetTall(ScrH() - self.paddingT - self.paddingB - size)
	else
		self.navbar:SetSize(size, ScrH() - self.paddingT - self.paddingB)
		self.displayWindow:SetWide(ScrW() - self.paddingL - self.paddingR - size)
	end
end

-- Creates a button in the navbar, corresponding to a subpanel.
-- @realm client
-- @tab data The data for the subpanel's button, using ENUMS/PRSUBPANEL
function PANEL:CreateButton(data)
	local button = self.navbar:Add("DButton")
	--local buttonIcon = button:Add("DLabel")
	--local buttonText = button:Add("DLabel")

	-- We set this field to see whether or not the current subpanel is the same as the button's corresponding subpanel.
	button.id = data.id

	if self.navbarDock == TOP or navbarDock == BOTTOM then
		button:SetWide(ScrW()/10)
	else
		button:SetTall(ScrH()/15)
	end

	button:SetText("")
	button.icon = data.icon or "l"
	button.headerText = " "..(data.name or "Name")
	surface.SetFont("ixPRIcons")
	button.iconW, button.iconH = surface.GetTextSize(button.icon)

	surface.SetFont("prCategoryHeadingFont")
	button.headerTextW, button.headerTextH = surface.GetTextSize(button.headerText)
	
	button:DockMargin(0, 0, 8, 8)

	
	button.Paint = function(panel, w, h)
		surface.SetDrawColor(56, 56, 56)
		surface.DrawRect(0, 0, w, h)

		local textW, textH = panel.iconW + panel.headerTextW, panel.iconH + panel.headerTextH

		draw.SimpleText(panel.icon, "ixPRIcons", w/2 - textW/2, h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(panel.headerText, "prCategoryHeadingFont", w/2 - textW/2 + panel.iconW, h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

		--panel.textMarkup:Draw(w/2, h/2, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		if panel:IsHovered() or panel:IsChildHovered() then
			surface.SetDrawColor(0, 0, 0, 50)
			surface.DrawRect(0, 0, w, h)
			if panel:IsDown() then
				surface.DrawRect(0, 0, w, h)
			end
		end


		if panel.id == ix.gui.CurMenuPanel then
			surface.SetDrawColor(163, 163, 0)
		else
			surface.SetDrawColor(215, 215, 215)
		end
		surface.DrawOutlinedRect(0, 0, w, h, 1)

		--buttonIcon:PaintManual()
		--buttonText:PaintManual()
	end
	


	
	/*


	buttonIcon:Dock(LEFT)
	buttonText:Dock(LEFT)
	
	buttonIcon:SetFont("ixPRIcons")
	buttonText:SetFont("prCategoryHeadingFont")

	buttonIcon:SetText(data.icon or "l")
	buttonText:SetText(data.name or "Sample Text")

	buttonIcon:SizeToContents()
	buttonText:SizeToContents()

	button:DockMargin(0, 0, 10, 10)
	*/

	button.textMarkup = markup.Parse("<font=ixPRIcons><color=255, 255, 255>"..(data.icon or "l").."</font> <font=prCategoryHeadingFont>"..(data.name or "Name").."</font></color> ") 

	--button:DockPadding((button:GetWide() - buttonIcon:GetWide() - buttonText:GetWide() - 8)/2, 0, 0, 0)
	

	-- The buttons are docked perpendicular to your navbar's dock direction.
	if self.navbarDock == TOP or self.navbarDock == BOTTOM then
		button:Dock(LEFT)
		button:DockMargin(0, 0, 8, 0)
	else
		button:Dock(TOP)
		button:DockMargin(0, 0, 0, 8)
	end

	button.subpanel = self.subpanels[button.id]

	button.DoClick = function(panel)
		if !self:OnNavButtonClick(panel, panel.id) then return end
		if !self.animating then
			self:SetActiveSubpanel(panel.id, true)
		end
	end
end

--- Adds a subpanel to the list of subpanels.
-- @realm client
-- @string id The unique id of the subpanel.
function PANEL:AddSubpanel(id, data)
end

-- Returns the display window for the menu, where the subpanel is displayed.
-- @realm client
-- @treturn panel The menu's display window.
function PANEL:GetDisplayWindow()
	return self.displayWindow
end

--- Loads the data relating to the subpanels and creates both the subpanels and their buttons. This is meant to be overridden.
-- @realm client
function PANEL:SetupSubpanels()
end

--- Changes the current subpanel being displayed by the menu.
-- @realm client 
-- @string id The unique id of the subpanel.
-- @bool Whether or not to show the animation for changing the subpanel.
function PANEL:SetActiveSubpanel(id, showAnimation)
	if showAnimation then
		if !self.subpanels[id].populated then self.subpanels[id].PopulateFunc(self.subpanels[id]) end
		local wholePanel = self
		self.animating = true
		if self.navbarDock == TOP or self.navbarDock == BOTTOM then
			self.scrX = 0
			
			local animTime = self.animationTime or animationTime
			local subpanels = self.subpanels

			local wholePanel = self
			
			self.currentY = self:GetY() 
			
			local curPanel = self.subpanels[self.activeSubpanel]
			curPanel.currentX = 0
			local panelX = curPanel.xPos
			local otherPanel = self.subpanels[id]
			
			local otherPanelX = otherPanel.xPos

			self.activeSubpanel = id

			curPanel:InvalidateParent(true)
			
			LocalPlayer():EmitSound("helix/ui/press.wav")		

			local dummySubpanel = self:Add("Panel")
			otherPanel.PopulateFunc(dummySubpanel)
			dummySubpanel:Dock(NODOCK)
			dummySubpanel.isDummy = true

			local slideDirection = (otherPanelX-panelX)/math.abs(otherPanelX-panelX)
			--dummySubpanel:SetPos(curPanel:LocalToScreen(curPanel:GetPos()))
			dummySubpanel:SetX(ScrW()*slideDirection)
			dummySubpanel:SetSize(curPanel:GetSize())

			timer.Simple(0, function()
				wholePanel.animating = false

				dummySubpanel:MoveTo(self.paddingL, dummySubpanel:GetY(), animTime, 0, -1, function()
				curPanel:Hide()
				otherPanel:Show()
				timer.Simple(0, function()
					dummySubpanel:Hide()
					dummySubpanel:Remove()
				end)
			end)

			curPanel:MoveTo(ScrW()*-slideDirection, 0, animTime, 0, -1)

			end)
		else
			self.scrY = 0

			local subpanels = self.subpanels
			local animTime = self.animationTime or animationTime

			local wholePanel = self
			
			self.currentY = self:GetY() 
			
			local curPanel = self.subpanels[self.activeSubpanel]
			curPanel.currentY = 0
			local panelY = curPanel.yPos

			local otherPanel = self.subpanels[id]
			
			local otherPanelY = otherPanel.yPos

			self.activeSubpanel = id

			curPanel:InvalidateParent(true)
			
			LocalPlayer():EmitSound("helix/ui/press.wav")		

			local dummySubpanel = self:Add("Panel")
			otherPanel.PopulateFunc(dummySubpanel)
			dummySubpanel:Dock(NODOCK)
			dummySubpanel.isDummy = true

			local slideDirection = (otherPanelY-panelY)/math.abs(otherPanelY-panelY)
			dummySubpanel:SetPos(self.navbarSize, ScrH()*slideDirection)
			dummySubpanel:SetSize(curPanel:GetSize())

			timer.Simple(0, function()
				wholePanel.animating = false

				dummySubpanel:MoveTo(dummySubpanel:GetX(), self.paddingT, animTime, 0, -1, function()
					dummySubpanel:MakePopup()
					curPanel:Hide()
					otherPanel:Show()
					timer.Simple(0, function()
						dummySubpanel:Hide()
						dummySubpanel:Remove()
					end)
				end)

				curPanel:MoveTo(0, ScrH()*-slideDirection, animTime, 0, -1)

			end)
		end
	else
		if !self.subpanels[id].populated then self.subpanels[id].PopulateFunc(self.subpanels[id]) end
		if self.activeSubpanel then
			self.subpanels[self.activeSubpanel]:Hide()
		end	
		self.subpanels[id]:Show()
		self.activeSubpanel = id
	end
end

function PANEL:OnNavButtonClick(button, subpanelID)
	return true
end


vgui.Register("prMenu", PANEL, "EditablePanel")