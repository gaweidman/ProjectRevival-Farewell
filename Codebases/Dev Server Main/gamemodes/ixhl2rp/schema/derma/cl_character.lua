
local gradient = surface.GetTextureID("vgui/gradient-d")
local audioFadeInTime = 2
local animationTime = 0.5
local matrixZScale = Vector(1, 1, 0.0001)

-- character menu panel
DEFINE_BASECLASS("ixSubpanelParent")
local PANEL = {}

function PANEL:Init()
	self:SetSize(self:GetParent():GetSize())
	self:SetPos(0, 0)

	self.childPanels = {}
	self.subpanels = {}
	self.activeSubpanel = ""

	self.currentDimAmount = 0
	self.currentY = 0
	self.currentScale = 1
	self.currentAlpha = 255
	self.targetDimAmount = 255
	self.targetScale = 0.9
end

function PANEL:Dim(length, callback)
	length = length or animationTime
	self.currentDimAmount = 0

	self:CreateAnimation(length, {
		target = {
			currentDimAmount = self.targetDimAmount,
			currentScale = 1
		},
		easing = "outCubic",
		OnComplete = callback
	})

	self:OnDim()
end

function PANEL:Undim(length, callback)
	length = length or animationTime
	self.currentDimAmount = self.targetDimAmount

	self:CreateAnimation(length, {
		target = {
			currentDimAmount = 0,
			currentScale = 1
		},
		easing = "outCubic",
		OnComplete = callback
	})

	self:OnUndim()
end

function PANEL:OnDim()
end

function PANEL:OnUndim()
end

function PANEL:Paint(width, height)
	local amount = self.currentDimAmount
	local bShouldScale = self.currentScale != 1
	local matrix

	-- draw child panels with scaling if needed
	BaseClass.Paint(self, width, height)

	if (amount > 0) then
		local color = Color(0, 0, 0, amount)

		surface.SetDrawColor(color)
		surface.DrawRect(0, 0, width, height)
	end
end

vgui.Register("ixCharMenuPanel", PANEL, "ixSubpanelParent")

-- character menu main button list
PANEL = {}

function PANEL:Init()
	local parent = self:GetParent()
	self:SetSize(parent:GetWide() * 0.25, parent:GetTall())

	self:GetVBar():SetWide(0)
	self:GetVBar():SetVisible(false)
end

function PANEL:Add(name)
	local panel = vgui.Create(name, self)
	panel:Dock(TOP)

	return panel
end

function PANEL:SizeToContents()
	self:GetCanvas():InvalidateLayout(true)

	-- if the canvas has extra space, forcefully dock to the bottom so it doesn't anchor to the top
	if (self:GetTall() > self:GetCanvas():GetTall()) then
		self:GetCanvas():Dock(BOTTOM)
	else
		self:GetCanvas():Dock(NODOCK)
	end
end

vgui.Register("ixCharMenuButtonList", PANEL, "DScrollPanel")

-- main character menu panel
PANEL = {}

AccessorFunc(PANEL, "bUsingCharacter", "UsingCharacter", FORCE_BOOL)

function PANEL:Init()
	local parent = self:GetParent()
	local padding = self:GetPadding()
	local halfWidth = ScrW() * 0.5
	local halfPadding = padding * 0.5
	local bHasCharacter = #ix.characters > 0

	self.bUsingCharacter = LocalPlayer().GetCharacter and LocalPlayer():GetCharacter()
	self:DockPadding(padding, padding, padding, padding)

	local infoLabel = self:Add("DLabel")
	infoLabel:SetTextColor(Color(255, 255, 255, 25))
	infoLabel:SetFont("ixMenuMiniFont")
	infoLabel:SetText(L("Project Revival ") ..Schema.Version)
	infoLabel:SizeToContents()
	infoLabel:SetPos(ScrW() - infoLabel:GetWide() - 4, ScrH() - infoLabel:GetTall() - 4)

	local topBar = self:Add("Panel")
	topBar:SetSize(ScrW(), ScrH())
	topBar:SetPos(0, 0)
	topBar.Paint = function(panel, width, height)
		ix.util.DrawBlurAt(0, 0, width, height, 10, 0.2, 200)
		surface.SetDrawColor(85, 85, 85, 30)
		surface.DrawRect(0, 0, width, height)

		for _, v in ipairs(panel:GetChildren()) do
			v:PaintManual()
		end
		
	end

	local logo = Schema.logo and ix.util.GetMaterial(Schema.logo)

	if (logo and !logo:IsError()) then
		local logoPadding = ScrW()/30
		local logoImage = topBar:Add("DImage")
		logoImage:SetMaterial(logo)
		logoImage:SetSize(halfWidth, halfWidth * logo:Height() / logo:Width())
		logoImage:SetPos(logoPadding/2, logoPadding/2)
		logoImage:SetPaintedManually(true)

		topBar:SetTall(logoImage:GetTall() + logoPadding)

		local plyBar = topBar:Add("Panel")
		plyBar:SetSize(ScrW()/6, 64)
		plyBar:SetPos(ScrW() - logoPadding/2 - plyBar:GetWide(), topBar:GetTall()/2 - plyBar:GetTall()/2)

		plyBar.Paint = function(panel, w, h)
			surface.SetDrawColor(133, 64, 7)	
			surface.DrawRect(0, 0, w, h)
		end

		plyBar.PaintOver = function(panel, w, h)
			surface.SetDrawColor(249, 122, 22)
			surface.DrawOutlinedRect(0, 0, w, h, 1)
			surface.DrawRect(64, 0, 1, 64)
		end

		local plyImage = plyBar:Add("AvatarImage")
		plyImage:Dock(LEFT)
		plyImage:SetSize(64, 64)
		self.plyName = plyBar:Add("ixLabel")
		self.plyName:Dock(FILL)
		self.plyName:SetFont("DermaLarge")
		self.plyName:SetScaleWidth(true)
		local plyName = self.plyName
		local ply = LocalPlayer()
		if !ply.SteamName or ply:SteamName() == nil then
			timer.Simple(0.25, function()
				plyImage:SetPlayer(LocalPlayer(), 64)
				plyName:SetText(ply:SteamName())
			end)
		else
			plyImage:SetPlayer(LocalPlayer(), 64)
			plyName:SetText(ply:SteamName())
		end
	else
		
	end

	-- button list
	self.mainButtonList = self:Add("ixCharMenuButtonList")
	
	-- create character button
	local createButton = self.mainButtonList:Add("ixMenuButton")
	createButton:SetText("New Character")
	createButton:SizeToContents()
	createButton:SetContentAlignment(6)
	createButton.DoClick = function(panel)
		local maximum = hook.Run("GetMaxPlayerCharacter", LocalPlayer()) or ix.config.Get("maxCharacters", 5)
		-- don't allow creation if we've hit the character limit
		if (#ix.characters >= maximum) then
			self:GetParent():ShowNotice(3, L("maxCharacters"))
			return
		end

		
		local parent = panel:GetParent():GetParent():GetParent():GetParent()
		local charPanel = parent.newCharacterPanel
		if !IsValid(charPanel) then
			charPanel = self:GetParent():Add("ixCharMenuNew")
			charPanel:Dock(FILL)
			charPanel:MoveToFront()
			parent.newCharacterPanel = charPanel
		else
			charPanel:MoveToFront()
			charPanel:Show()
		end

		self:Hide()
		
		
	end

	-- load character button
	self.loadButton = self.mainButtonList:Add("ixMenuButton")
	self.loadButton:SetText("Load Character")
	self.loadButton:SizeToContents()
	self.loadButton:SetContentAlignment(6)
	self.loadButton.DoClick = function()
		self:Dim()
		parent.loadCharacterPanel:SlideUp()
	end

	if (!bHasCharacter) then
		self.loadButton:SetDisabled(true)
	end

	-- community button
	local extraURL = ix.config.Get("communityURL", "")
	local extraText = ix.config.Get("communityText", "@community")

	if (extraURL != "" and extraText != "") then
		if (extraText:sub(1, 1) == "@") then
			extraText = L(extraText:sub(2))
		end
		/*


		local extraButton = self.mainButtonList:Add("ixMenuButton")
		extraButton:SetText(extraText, true)
		extraButton:SizeToContents()
		extraButton:SetContentAlignment(6)
		extraButton.DoClick = function()
			gui.OpenURL(extraURL)
		end

		*/
	end

	-- leave/return button
	self.returnButton = self.mainButtonList:Add("ixMenuButton")
	self.returnButton:SetContentAlignment(6)
	self:UpdateReturnButton()
	self.returnButton.DoClick = function()
		if (self.bUsingCharacter) then
			parent:Close()
		else
			RunConsoleCommand("disconnect")
		end
	end

	self.mainButtonList:SizeToContents()
	self.mainButtonList:SetPos(ScrW() - self.mainButtonList:GetWide() -ScrH()*3/64, -ScrH()*3/64)

	local topBarEndPos = topBar:GetTall()

	local panelSpacing = ScrW()/128

	local noticeBar = self:Add("Panel")
	noticeBar:SetPos(0, topBarEndPos)
	noticeBar:SetSize(ScrW(), 5*ScrW()/256)
	noticeBar.Paint = function(panel, w, h)
		--surface.SetDrawColor(190, 30, 30)
		--surface.DrawRect(0, 0, w, h)
	end

	local newsStories = {
		A = {
			title = "The rerelease is here! What comes next for Project Revival?",
			image = Material("vgui/black"),
			url = "projectrevival.xyz"
		},

		B = {
			title = "You can play as a FUCKING ALIEN!!!",
			image = "vgui/project-revival/AlienBG.png",
			url = "projectrevival.xyz"
		},

		C = {
			title = "sargent balls lol",
			image = "vgui/project-revival/AdminBG.png",
			url = "projectrevival.xyz"
		}
	}

	local newsImg = self:Add("DImage")
	newsImg:SetPos(ScrW()/32, topBarEndPos + ScrW()/32)
	newsImg:SetImage("vgui/project-revival/news.png")
	newsImg:SetSize(ScreenScale(764/3/3/1.5), ScreenScale(143/3/3/1.5))

	self.newsPanelA = self:Add("prMainMenuFrame")
	self.newsPanelA:SetSize(ScreenScale(200), ScreenScale(140))
	self.newsPanelA:SetPos(ScrW()/32, newsImg:GetY() + newsImg:GetTall() + panelSpacing)
	self.newsPanelA:SetText(newsStories.A.title)
	self.newsPanelA.url = newsStories.A.url
	if isstring(newsStories.A.image) then
		self.newsPanelA:SetImage(newsStories.A.image)
	else
		self.newsPanelA:SetMaterial(newsStories.A.image)
	end

	self.newsPanelB = self:Add("prMainMenuFrame")
	self.newsPanelB:SetSize(ScreenScale(100) - panelSpacing, ScreenScale(70) - panelSpacing/2)
	self.newsPanelB:SetPos(self.newsPanelA:GetX() + self.newsPanelA:GetWide() + panelSpacing, self.newsPanelA:GetY())
	self.newsPanelB:SetText(newsStories.B.title)
	self.newsPanelB.url = newsStories.B.url
	if isstring(newsStories.B.image) then
		self.newsPanelB:SetImage(newsStories.B.image)
	else
		self.newsPanelB:SetMaterial(newsStories.B.image)
	end


	self.newsPanelC = self:Add("prMainMenuFrame")
	self.newsPanelC:SetSize(self.newsPanelB:GetWide(), self.newsPanelB:GetTall())
	self.newsPanelC:SetPos(self.newsPanelA:GetX() + self.newsPanelA:GetWide() + panelSpacing, self.newsPanelB:GetY() + self.newsPanelB:GetTall() + panelSpacing)
	self.newsPanelC:SetText(newsStories.C.title)
	self.newsPanelC.url = newsStories.C.url
	if isstring(newsStories.C.image) then
		self.newsPanelC:SetImage(newsStories.C.image)
	else
		self.newsPanelC:SetMaterial(newsStories.C.image)
	end

end

function PANEL:UpdateReturnButton(bValue)
	if (bValue != nil) then
		self.bUsingCharacter = bValue
	end

	self.returnButton:SetText(self.bUsingCharacter and "Return to Game" or "Disconnect")
	self.returnButton:SizeToContents()
end

function PANEL:OnDim()
	-- disable input on this panel since it will still be in the background while invisible - prone to stray clicks if the
	-- panels overtop slide out of the way
	self:SetMouseInputEnabled(false)
	self:SetKeyboardInputEnabled(false)
	for k, v in ipairs(self:GetChildren()) do
		v:Hide()
	end
end

function PANEL:OnUndim()
	self:SetMouseInputEnabled(true)
	self:SetKeyboardInputEnabled(true)

	-- we may have just deleted a character so update the status of the return button
	self.bUsingCharacter = LocalPlayer().GetCharacter and LocalPlayer():GetCharacter()
	self:UpdateReturnButton()

	for k, v in ipairs(self:GetChildren()) do
		v:Show()
	end
end

function PANEL:OnClose()
	for _, v in pairs(self:GetChildren()) do
		if (IsValid(v)) then
			v:SetVisible(false)
		end
	end
end

function PANEL:PerformLayout(width, height)
	local padding = self:GetPadding()

	--self.mainButtonList:SetPos(ScrW()/2, ScrH()/2)
end

vgui.Register("ixCharMenuMain", PANEL, "ixCharMenuPanel")

-- container panel
PANEL = {}

function PANEL:Init()
	if (IsValid(ix.gui.loading)) then
		ix.gui.loading:Remove()
	end

	if (IsValid(ix.gui.characterMenu)) then
		if (IsValid(ix.gui.characterMenu.channel)) then
			ix.gui.characterMenu.channel:Stop()
		end

		ix.gui.characterMenu:Remove()
	end

	self:SetSize(ScrW(), ScrH())
	self:SetPos(0, 0)

	-- main menu panel
	self.mainPanel = self:Add("ixCharMenuMain")
	

	self.background = vgui.Create("DImage", self)

	self.background:SetPos(0, 0)
	self.background:SetSize(ScrW(), ScrH())
	self.background:Dock(FILL)
	--local backgroundImg = ix.util.GetMaterial("vgui/project-revival/PlazaBG.jpg")
	self.background:SetImage("vgui/project-revival/trainstationbg.png")

	-- new character panel
	self.newCharacterPanel = self:Add("ixCharMenuNew")
	self.newCharacterPanel:Hide()
	self.newCharacterPanel:Dock(FILL)

	-- load character panel
	self.loadCharacterPanel = self:Add("ixCharMenuLoad")
	self.loadCharacterPanel:SlideDown(0)

	-- notice bar
	self.notice = self:Add("ixNoticeBar")

	-- finalization
	self:MakePopup()
	self.currentAlpha = 255
	self.volume = 0

	ix.gui.characterMenu = self

	if (!IsValid(ix.gui.intro)) then
		self:PlayMusic()
	end

	self.background:MoveToBack()

	hook.Run("OnCharacterMenuCreated", self)
end

function PANEL:PlayMusic()
	local path = "sound/" .. ix.config.Get("music")
	local url = path:match("http[s]?://.+")
	local play = url and sound.PlayURL or sound.PlayFile
	path = url and url or path

	play(path, "noplay", function(channel, error, message)
		if (!IsValid(self) or !IsValid(channel)) then
			return
		end

		channel:SetVolume(self.volume or 0)
		channel:Play()

		self.channel = channel

		self:CreateAnimation(audioFadeInTime, {
			index = 10,
			target = {volume = 1},

			Think = function(animation, panel)
				if (IsValid(panel.channel)) then
					panel.channel:SetVolume(self.volume * 0.5)
				end
			end
		})
	end)
end

function PANEL:Think()
	if IsValid(self.plyName) then
		if self.plyName.Empty then
			if LocalPlayer().GetName != nil then
				self.plyName:SetText(LocalPlayer():GetName())
				self.plyName.Empty = false
			end
		end
	end
end

function PANEL:ShowNotice(type, text)
	self.notice:SetType(type)
	self.notice:SetText(text)
	self.notice:Show()
end

function PANEL:HideNotice()
	if (IsValid(self.notice) and !self.notice:GetHidden()) then
		self.notice:Slide("up", 0.5, true)
	end
end

function PANEL:OnCharacterDeleted(character)
	if (#ix.characters == 0) then
		self.mainPanel.loadButton:SetDisabled(true)
		self.mainPanel:Undim() -- undim since the load panel will slide down
	else
		self.mainPanel.loadButton:SetDisabled(false)
	end

	self.loadCharacterPanel:OnCharacterDeleted(character)
end

function PANEL:OnCharacterLoadFailed(error)
	self.loadCharacterPanel:SetMouseInputEnabled(true)
	self.loadCharacterPanel:SlideUp()
	self:ShowNotice(3, error)
end

function PANEL:IsClosing()
	return self.bClosing
end

function PANEL:Close(bFromMenu)
	self.bClosing = true
	self.bFromMenu = bFromMenu

	local fadeOutTime = animationTime

	self:CreateAnimation(fadeOutTime, {
		index = 1,
		target = {currentAlpha = 0},
		easing = "outExpo",

		Think = function(animation, panel)
			panel:SetAlpha(panel.currentAlpha)
		end,

		OnComplete = function(animation, panel)
			panel:Remove()
		end
	})

	self:CreateAnimation(fadeOutTime - 0.1, {
		index = 10,
		target = {volume = 0},

		Think = function(animation, panel)
			if (IsValid(panel.channel)) then
				panel.channel:SetVolume(self.volume * 0.5)
			end
		end,

		OnComplete = function(animation, panel)
			if (IsValid(panel.channel)) then
				panel.channel:Stop()
				panel.channel = nil
			end
		end
	})

	-- hide children if we're already dimmed
	if (bFromMenu) then
		for _, v in pairs(self:GetChildren()) do
			if (IsValid(v)) then
				v:SetVisible(false)
			end
		end
	else
		-- fade out the main panel quicker because it significantly blocks the screen
		self.mainPanel.currentAlpha = 255

		self.mainPanel:CreateAnimation(animationTime * 2, {
			target = {currentAlpha = 0},
			easing = "outQuint",

			Think = function(animation, panel)
				panel:SetAlpha(panel.currentAlpha)
			end,

			OnComplete = function(animation, panel)
				panel:SetVisible(false)
			end
		})
	end

	-- relinquish mouse control
	self:SetMouseInputEnabled(false)
	self:SetKeyboardInputEnabled(false)
	gui.EnableScreenClicker(false)
end

function PANEL:Paint(width, height)
	surface.SetTexture(gradient)
	surface.SetDrawColor(0, 0, 0, 255)
	surface.DrawTexturedRect(0, 0, width, height)

	if (!ix.option.Get("cheapBlur", false)) then
		surface.SetDrawColor(0, 0, 0, 150)
		surface.DrawTexturedRect(0, 0, width, height)
	end
end

function PANEL:PaintOver(width, height)
	if (self.bClosing and self.bFromMenu) then
		surface.SetDrawColor(color_black)
		surface.DrawRect(0, 0, width, height)
	end
end

function PANEL:OnRemove()
	if (self.channel) then
		self.channel:Stop()
		self.channel = nil
	end
end

vgui.Register("ixCharMenu", PANEL, "EditablePanel")

if (IsValid(ix.gui.characterMenu)) then
	ix.gui.characterMenu:Remove()

	--TODO: REMOVE ME
	ix.gui.characterMenu = vgui.Create("ixCharMenu")
end

PANEL = {}

function PANEL:Init()
	self:SetSize(500, 350)
	self:Center()
	self:MakePopup()
	self:SetTitle("")
	
	local wholePanel = self

	self.display = self:Add("DImageButton")
	self.display:SetPos(5, 20)
	self.display:SetSize(self:GetWide() - 10, self:GetTall() - 25)
	self.display:SetImage("vgui/project-revival/testbg.png")
	self.display:SetKeepAspect(true)
	self.display.DoClick = function(panel)
		gui.OpenURL(wholePanel.url)
	end

	local textPanel = self:Add("DPanel")
	textPanel:Dock(BOTTOM)
	textPanel:SetTall(50)
	textPanel:SetBackgroundColor(Color(15, 15, 15, 200))

	self.text = textPanel:Add("ixLabel")
	self.text:Dock(FILL)
	self.text:SetText("The rerelease is here! What comes next for Project Revival?")
	self.text:SetFont("Trebuchet24")
	self.text:SetScaleWidth(true)
	self.text:DockMargin(8, 8, 8, 8)
	self.text:SetContentAlignment(1)
	
	self:ShowCloseButton(false)
end

function PANEL:SetText(text)
	self.text:SetText(text)
end

function PANEL:GetText()
	return self.text:GetText()
end

function PANEL:SetImage(img)
	self.display:SetImage(img)
end

function PANEL:SetMaterial(mat)
	self.display:SetMaterial(mat)
end

function PANEL:GetImage()
	return self.display:GetImage()
end

function PANEL:GetMaterial()
	return self.display:GetMaterial()
end

function PANEL:OnSizeChanged(newW, newH)
	local wholePanel = self
	timer.Simple(0, function()
		wholePanel.display:SetSize(newW - 10, newH - 25)
	end)
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(222, 104, 49)
	--surface.DrawOutlinedRect(0, 0, w, h)
	draw.NoTexture()
	surface.DrawPoly({{ x = 0, y = 20 }, 
	{ x = 20, y = 0 }, 
	{ x = w, y = 0 }, 
	{ x = w, y = h }, 
	{ x = 0, y = h}} )

	

	local outlineWidth = 5

	--surface.DrawRect(0, 20, w, h - 20, 1)

	surface.SetDrawColor(44, 44, 44)
	surface.DrawRect(outlineWidth, 20, w - outlineWidth*2, h - 20 - outlineWidth)
	
	surface.SetDrawColor(245, 151, 64)
	surface.DrawPoly({
		{x = 10, y = 10},
		{x = 20, y = 0},
		{x = 20, y = 10},
	})

	surface.DrawRect(20, 0, w - 20, 10)
	/*

	surface.DrawPoly({{ x = outlineWidth, y = 20 + outlineWidth }, 
	{ x = 20 + outlineWidth, y = outlineWidth }, 
	{ x = w - outlineWidth, y = outlineWidth }, 
	{ x = w - outlineWidth, y = h - outlineWidth}, 
	{ x = outlineWidth, y = h - outlineWidth}} )

	*/

	--surface.SetDrawColor(222, 104, 49)
	
end

vgui.Register("prMainMenuFrame", PANEL, "DFrame")

