
local menuOpenCloseTime = 1
local menuSlideTime = 0.25
local matrixZScale = Vector(1, 1, 0.0001)

DEFINE_BASECLASS("prMenu")
local PANEL = {}

function PANEL:Init()
	if (IsValid(ix.gui.menu)) then
		ix.gui.menu:Remove()
	end

	ix.gui.menu = self

	self:SetZPos(-999)

	self.noAnchor = CurTime() + 0.4
	self.anchorMode = true

	self.projectedTexturePosition = Vector(0, 0, 6)
	self.projectedTextureRotation = Angle(-45, 60, 0)

	self:SetMouseInputEnabled(true)
	self:SetKeyboardInputEnabled(true)
	gui.EnableScreenClicker(true)

	self:SetSize(ScrW(), ScrH())
	self:SetPos(0, 0)

	self.currentAlpha = 0
	self.currentBlur = 0

	local margin = ScrW() * 0.025

	self:SetMargin(margin, margin, margin, margin)
	
	self.manualChildren = {}

	self:SetNavbarDock(TOP)
	self:SetNavbarSize(ScrH()/15)

	self:MakePopup()
	self:SetupSubpanels()

	self.charButton = self.navbar:Add("DButton")
	self.charButton:SetWide(ScrW()/8)

	self.charButton:SetText("Return to Main Menu")
	self.charButton:SetFont("prCategoryHeadingFont")

	self.charButton.DoClick = function(panel)
		self:Remove()
		vgui.Create("ixCharMenu")
	end
	
	self.charButton.Paint = function(panel, w, h)
		surface.SetDrawColor(56, 56, 56)
		surface.DrawRect(0, 0, w, h)

		if panel:IsHovered() or panel:IsChildHovered() then
			surface.SetDrawColor(0, 0, 0, 50)
			surface.DrawRect(0, 0, w, h)
			if panel:IsDown() then
				surface.DrawRect(0, 0, w, h)
			end
		end


		surface.SetDrawColor(215, 215, 215)
		surface.DrawOutlinedRect(0, 0, w, h, 1)
	end

	self.charButton:Dock(RIGHT)

	self:CreateAnimation(menuOpenCloseTime, {
		target = {currentAlpha = 255},
		easing = "outExpo",

		Think = function(animation, panel)
			panel:SetAlpha(panel.currentAlpha)
		end
	})
end

function PANEL:GetStandardSubpanelSize()
	--return ScrW() - 2*ScrW()/40, ScrH() - self.topBarHeight - 2*ScrW()/40
	return ScrW(), ScrH()
end

function PANEL:StartRemove()
	self.isClosing = true

	local descVal = self.subpanels["character"].shortDesc:GetValue()
	local extDescVal = self.subpanels["character"].extDesc:GetValue()
	local charDesc = LocalPlayer():GetCharacter():GetDescription()

	local match = descVal:utf8lower():match("([_%w]+)")
	if (!match) then
		local post = string.Explode(" ", descVal)
		local len = string.len(post[1])

		descVal = post[1]:utf8sub(2, len)
	end

	if descVal != charDesc and extDescVal != charDesc then
		
	elseif descVal != charDesc and descVal != "" then
		ix.command.Send("chardesc", descVal)
		
		
	elseif extDescVal != charDesc and extDescVal != "" then
		ix.command.Send("chardesc", extDescVal)
	end

	if IsValid(self.subpanels["character"].model) then
		self.subpanels["character"].model:Remove()
	end

	if IsValid(self.subpanels["crafting"] and self.subpanels["crafting"].model) then
		self.subpanels["crafting"].rightBar:Clear()
	end

	self:SetMouseInputEnabled(false)
	self:SetKeyboardInputEnabled(false)
	gui.EnableScreenClicker(false)

	self:CreateAnimation(menuOpenCloseTime*0.5, {
		target = {currentAlpha = 0},
		easing = "outExpo",

		-- we don't animate the blur because blurring doesn't draw things
		-- with amount < 1 very well, resulting in jarring transition
		Think = function(animation, panel)
			panel:SetAlpha(panel.currentAlpha)
		end,

		OnComplete = function(animation, panel)
			if (IsValid(panel.projectedTexture)) then
				panel.projectedTexture:Remove()
			end
			panel:Remove()
		end
	})

	timer.Simple(menuOpenCloseTime*0.5, function()
		if IsValid(self) then
			if (IsValid(self.projectedTexture)) then
				self.projectedTexture:Remove()
			end
			self:Remove()
		end 
	end)

	
end

function PANEL:OnRemove()
end

function PANEL:Think()

	if (IsValid(self.projectedTexture)) then
		local forward = LocalPlayer():GetForward()
		forward.z = 0

		local right = LocalPlayer():GetRight()
		right.z = 0

		self.projectedTexture:SetBrightness(self.overviewFraction * 4)
		self.projectedTexture:SetPos(LocalPlayer():GetPos() + right * 16 - forward * 8 + self.projectedTexturePosition)
		self.projectedTexture:SetAngles(forward:Angle() + self.projectedTextureRotation)
		self.projectedTexture:Update()
	end

	if (self.isClosing and self.currentAlpha <= 0) then
		self:Remove()
	end

	local bTabDown = input.IsKeyDown(KEY_TAB)

	if (bTabDown and (self.noAnchor or CurTime() + 0.4) < CurTime() and self.anchorMode) then
		self.anchorMode = false
		surface.PlaySound("buttons/lightswitch2.wav")
	end

	if ((!self.anchorMode and !bTabDown) or gui.IsGameUIVisible()) then
		self:StartRemove()
	end

	local ply = LocalPlayer()
	local char = ply:GetCharacter()
	local curTime = CurTime()
	local nextCheck = self.subpanels.character.nextCheck or CurTime()

	-- character menu check
	if curTime >= nextCheck then
		self.subpanels.character.nextCheck = curTime + 0.5
		local realMoney = tostring(char:GetMoney())
		if self.subpanels["character"].fields.tokens:GetText() != realMoney then
			self.subpanels["character"].fields.tokens:SetText(realMoney)
		end

		local realFaction = ix.faction.Get(char:GetFaction()).name
		if self.subpanels["character"].fields.faction:GetText() != realFaction then
			self.subpanels["character"].fields.faction:SetText(realFaction)
		end

		local realHealth = ply:Health()

		local realHealth = ply:Health()
		if (realHealth > 80) then
			realHealth = "Good"
		elseif (realHealth > 60) then
			realHealth = "Hurt"
		elseif (realHealth > 40) then
			realHealth = "Wounded"
		elseif (realHealth > 20) then
			realHealth = "Heavily Wounded"
		elseif (realHealth > 0) then
			realHealth = "Near Death"
		else
			realHealth = "Dead"
		end

		if self.subpanels["character"].fields.health:GetText() != realHealth then
			self.subpanels["character"].fields.health:SetText(realHealth)
		end

		local realDT = tostring(char:GetDT()["Sharp"])
		if self.subpanels["character"].fields.dt:GetText() != realDT then
			self.subpanels["character"].fields.dt:SetText(realDT)
		end

		local realModel = ply:GetModel()

		if self.subpanels["character"].model.GetModel == nil then return end
		
		if self.subpanels["character"].model:GetModel() != realModel then
			self.subpanels["character"].model:SetModel(realModel)
		end

		local modelEnt = self.subpanels["character"].model:GetEntity()

		local realSkin = ply:GetSkin()
		if modelEnt:GetSkin() != realSkin then
			modelEnt:SetSkin(realSkin)
		end

		local bodygroups = modelEnt:GetBodyGroups()
		for k, v in ipairs(bodygroups) do
			local realBodygroup = ply:GetBodygroup(v.id)
			if modelEnt:GetBodygroup(v.id) != ply:GetBodygroup(v.id) then
				modelEnt:SetBodygroup(v.id, realBodygroup)
			end
		end

		
	end
end

/*

function PANEL:Paint(width, height)
	ix.util.DrawBlur(self, (self.currentAlpha or 0)/255 * 5, nil, 200)

	local bShouldScale = self.currentAlpha != 255

	if (IsValid(ix.gui.inv1) and ix.gui.inv1.childPanels) then
		for i = 1, #ix.gui.inv1.childPanels do
			local panel = ix.gui.inv1.childPanels[i]

			if (IsValid(panel)) then
				panel:PaintManual()
			end
		end
	end
end

*/

function PANEL:PerformLayout()

end

function PANEL:SetupSubpanels()
	local subpanels = {}
	hook.Run("CreateMenuButtons", subpanels)

	subpanels.inv = nil

	for id, data in pairs(subpanels) do
		if istable(data) then
			data.id = id
			self:CreateButton(data)

			local subpanel = self.displayWindow:Add("Panel")
			subpanel:Dock(FILL)
			subpanel.id = id
			if data.populate then 
				data.populate(subpanel)
			end

			subpanel.PopulateFunc = data.populate

			-- This is the x position of the subpanels, used for animating. This is relative to each other in panels, and is not equivalent to real screen pixels.
			subpanel.xPos = table.Count(self.subpanels) + 1
			subpanel:Hide()

			self.subpanels[id] = subpanel
		end
	end

	if !ix.gui.CurMenuPanel then
		self:SetActiveSubpanel("character", false)
	else
		self:SetActiveSubpanel(ix.gui.CurMenuPanel, false)
	end
end

function PANEL:SetActiveSubpanel(id, showAnimation)
	if showAnimation then
		local wholePanel = self
		self.animating = true
		if self.navbarDock == TOP or self.navbarDock == BOTTOM then
			self.scrX = 0

			local subpanels = self.subpanels

			local wholePanel = self
			
			self.currentY = self:GetY() 
			
			local curPanel = self.subpanels[ix.gui.CurMenuPanel]
			curPanel.currentX = 0
			local panelX = curPanel.xPos
			local otherPanel = self.subpanels[id]
			
			local otherPanelX = otherPanel.xPos

			ix.gui.CurMenuPanel = id

			curPanel:InvalidateParent(true)
			
			LocalPlayer():EmitSound("helix/ui/press.wav")		

			local dummySubpanel = self:Add("Panel")
			otherPanel.PopulateFunc(dummySubpanel)
			dummySubpanel:Dock(NODOCK)
			
			if IsValid(dummySubpanel.model) then dummySubpanel.model:Hide() end

			local slideDirection = (otherPanelX-panelX)/math.abs(otherPanelX-panelX)
			dummySubpanel:SetPos(curPanel:LocalToScreen(curPanel:GetPos()))
			dummySubpanel:SetX(1920*slideDirection)	
			dummySubpanel:SetSize(curPanel:GetSize())

			timer.Simple(0, function()
				dummySubpanel:MoveTo(self.paddingL, dummySubpanel:GetY(), menuSlideTime, 0, -1, function()
					wholePanel.animating = false
					curPanel:Hide()
					otherPanel:Show()
					timer.Simple(0, function()
						dummySubpanel:Hide()
						dummySubpanel:Remove()
					end)

					if IsValid(curPanel.scrollPanel) then
						curPanel.scrollPanel:GetVBar():SetScroll(0)
					end
				end)
				curPanel:MoveTo(1920*-slideDirection, 0, menuSlideTime, 0, -1)
			end)

		else
			
		end
	else
		if ix.gui.CurMenuPanel then
			self.subpanels[ix.gui.CurMenuPanel]:Hide()
		end	
		self.subpanels[id]:Show()
		ix.gui.CurMenuPanel = id
	end

	
end

vgui.Register("ixMenu", PANEL, "prMenu")

if (IsValid(ix.gui.menu)) then
	ix.gui.menu:Remove()
end

ix.gui.lastMenuTab = nil

hook.Add("CreateMenuButtons", "ixCharOverview", function(subpanels)
	subpanels["character"] = {
		icon = "z", 
		name = "Character",
		populate = function(container)
			do
				container.topBarHeight = ScrH()/15
				local scrH = ScrH()
				local padding = ScrW()/40
			
				local canvasW = ScrW() - padding*2
				local canvasH = ScrH() - padding*2 - ScrH()/15
			
			
				container.leftBar = vgui.Create("DPanel", container) 
				container.middleBar = vgui.Create("DPanel", container) 
				container.rightBar = vgui.Create("DPanel", container) 
				local bottomBarHeight = scrH/15
			
				container.PaintOver = function(panel, w, h)
					surface.SetDrawColor(153, 73, 36)
					surface.DrawOutlinedRect(0, 0, w, h, 1)
				end
			
				local barWidth = (ScrW() - padding*2)/3
			
				local itemIconSize = math.floor(ScrW()*0.06)
				local itemGridMargin = 2
				local barPadding = math.floor(ScreenScale(4))
				
				container.leftBar:SetSize(canvasW/5, scrH - container.topBarHeight - padding*2)
				container.rightBar:SetSize(barPadding*2 + itemIconSize*6 + itemGridMargin*5, scrH - container.topBarHeight - padding*2)
				container.middleBar:SetSize(canvasW - container.leftBar:GetWide() - container.rightBar:GetWide(), scrH - container.topBarHeight - padding*2)
			
				container.rightBar:DockPadding(0, barPadding, barPadding, barPadding)
				container.middleBar:DockPadding(barPadding, barPadding, barPadding, barPadding)
			
				container.leftBar:Dock(LEFT)
				container.middleBar:Dock(LEFT)
				container.rightBar:Dock(LEFT)
			
				/*
			
			
				container.topBar.Paint = function(self, w, h)
					surface.SetDrawColor(0, 255, 255)
					surface.DrawRect(0, 0, w, h)
			
					for k, v in ipairs(container:GetChildren()) do
						v:PaintManual()
					end
				end
			
				*/
			
				
				local barBgColor = Color(145, 65, 45, 255)
			
				container.middleBar.Paint = function(this, w, h)
					surface.SetDrawColor(barBgColor)
					surface.DrawRect(0, 0, w, h)
			
					for k, v in ipairs(this:GetChildren()) do
						v:PaintManual()
					end
				end
			
				container.rightBar.Paint = function(this, w, h)
					surface.SetDrawColor(barBgColor)
					surface.DrawRect(0, 0, w, h)
			
					for k, v in ipairs(this:GetChildren()) do
						v:PaintManual()
					end
			
					if (IsValid(ix.gui.inv1) and ix.gui.inv1.childPanels) then
						for i = 1, #ix.gui.inv1.childPanels do
							local panel = ix.gui.inv1.childPanels[i]
				
							if (IsValid(panel)) then
								panel:PaintManual()
							end
						end
					end
				end
			
				local ply = LocalPlayer()
				local char = ply:GetCharacter()
				-- Middle Bar
				do
					local isCitizen = char:GetFaction() == FACTION_CITIZEN
			
					local health = ply:Health()
					local armor = ply:Armor()
			
					if (health > 80) then
						health = "Good"
					elseif (health > 60) then
						health = "Hurt"
					elseif (health > 40) then
						health = "Wounded"
					elseif (health > 20) then
						health = "Heavily Wounded"
					elseif (health > 0) then
						health = "Near Death"
					else
						health = "Dead"
					end
			
					if armor == 0 then
						armor = "None"
					elseif (armor > 0 and armor <= 20) then
						armor = "Barely Armored"
					elseif (armor > 20 and armor <= 50) then
						armor = "Somewhat Armored"
					elseif (armor > 50 and armor <= 100) then
						armor = "Armored"
					elseif (armor > 100 and armor <= 150) then
						armor = "Heavily Armored"
					elseif (armor > 150 and armor <= 200) then
						armor = "Very Heavily Armored"
					elseif (armor > 200) then
						armor = "Extremely Heavily Armored"
					end
			
					local fields = {
						faction = {
							["title"] = "Faction",
							["value"] = ix.faction.Get(char:GetFaction()).name,
							["icon"] = "y"
						},
						tokens = {
							["title"] = "Tokens",
							["value"] = char:GetMoney(),
							["icon"] = "x"
						},
						health = {
							["title"] = "Health",
							["value"] = health,
							["icon"] = "A"
						},
						dt = {
							["title"] = "Damage Threshold",
							["value"] = char:GetDT()["Sharp"],
							["icon"] = "k"
						}
					}
			
					if isCitizen then 
						local cid = char:GetData("cid", nil)
						if cid == nil then cid = "None" else cid = "#"..cid end
						table.insert(fields, 2, {["title"] = "Citizen ID", ["value"] = cid, ["icon"] = "l"})
					end

					local buttonColor = Color(96, 38, 25, 255)
					local buttonSkin = function(panel, w, h)
						surface.SetDrawColor(buttonColor)
						surface.DrawRect(0, 0, w, h)

						surface.SetDrawColor(0, 0, 0)
						surface.DrawOutlinedRect(0, 0, w, h, 1)
						
						if ix.gui.ModelPanelSelection != nil and panel.dataType != nil and ix.gui.ModelPanelSelection == panel.dataType then
							surface.SetDrawColor(0, 0, 0, 100)
							surface.DrawRect(0, 0, w, h)
						end

						if panel:IsHovered() then
							surface.SetDrawColor(0, 0, 0, 50)
							surface.DrawRect(0, 0, w, h)
						end
					end

					local btnClick = function(panel)
						if ix.gui.ModelPanelSelection != panel.dataType then
							ix.gui.ModelPanelSelection = panel.dataType

							if panel.dataType == "model" then
								container.model:Show()
								container.limbPnl:Hide()
							else
								container.model:Hide()
								container.limbPnl:Show()
							end
						end
					end

					local mdlImg = container.leftBar:Add("DImage")
					mdlImg:SetImage(ix.faction.Get(LocalPlayer():GetCharacter():GetFaction()).bgImage or "vgui/project-revival/plazabg.png")
					mdlImg:SetKeepAspect(true)
					mdlImg:Dock(FILL)
			
					local modelRow = container.leftBar:Add("Panel")
					modelRow.Paint = function(panel, w, h)
						surface.SetDrawColor(barBgColor)
						surface.DrawRect(0, 0, w, h)
					end

					modelRow:Dock(BOTTOM)
					modelRow:SetTall(28)
					local mdlBtnW = ScrW()/20

					

					local mdlBtn = modelRow:Add("DButton")
					local lmbBtn = modelRow:Add("DButton")

					mdlBtn.dataType = "model" 
					lmbBtn.dataType = "limb" 

					container.limbPnl = container.leftBar:Add("Panel")
					container.limbPnl:Dock(FILL)
					
					local limbMats = {
						--fullbody = Material("clockwork/limbs/body.png"),
						[HITGROUP_LEFTLEG] = Material("clockwork/limbs/lleg.png"),
						[HITGROUP_RIGHTLEG] = Material("clockwork/limbs/rleg.png"),
						[HITGROUP_HEAD] = Material("clockwork/limbs/head.png"),
						[HITGROUP_CHEST] = Material("clockwork/limbs/rarm.png"),
						[HITGROUP_LEFTARM] = Material("clockwork/limbs/larm.png"),
						[HITGROUP_RIGHTARM] = Material("clockwork/limbs/rarm.png"),
						[HITGROUP_STOMACH] = Material("clockwork/limbs/stomach.png"),
						[HITGROUP_CHEST] = Material("clockwork/limbs/chest.png")
					}

					local brokenColor =  Color(50, 50, 50)

					local bodyMargin = 50

					local bodyScale = 3

					local green = Color(0, 255, 0)

					local function DrawLimbHealth(x, y, name, health)
						local w = 100
						local h = 34
						surface.SetDrawColor(20, 20, 20)
						surface.DrawRect(x - w/2, y - h/2, w, h)

						surface.SetDrawColor(0, 255, 0)
						surface.DrawOutlinedRect(x - w/2, y - h/2, w, h, 1)

						draw.SimpleText(name, "DermaDefaultBold", x, y - h/2 + 8, green, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
						draw.SimpleText(health, "DermaDefault", x, y - h/2 + 22, green, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					end

					container.limbPnl.Paint = function(panel, w, h)
						--surface.SetMaterial(limbMats.fullbody)
						surface.SetDrawColor(255, 255, 255, 255)
						--surface.DrawTexturedRect(w/2 - 64*bodyScale, h/2 - 128*bodyScale, 128*bodyScale, 256*bodyScale)

						for bodypart, mat in pairs(limbMats) do
							surface.SetMaterial(mat)

							local limbHealth = char:GetLimbHealth(bodypart)
							local limbColor = HSVToColor(Lerp(limbHealth/100, 0, 120), 0.7, 0.7)

							if limbHealth <= 0 then limbColor = brokenColor end

							surface.SetDrawColor(limbColor)

							surface.DrawTexturedRect(w/2 - 64*bodyScale + bodyMargin/2, h/2 - 128*bodyScale + bodyMargin/2, 128*bodyScale - bodyMargin, 256*bodyScale - bodyMargin)
						end

						DrawLimbHealth(w/2, h/13, "Head", 100)
					end

					lmbBtn:Dock(LEFT)
					mdlBtn:Dock(LEFT)

					lmbBtn.DoClick = btnClick
					mdlBtn.DoClick = btnClick

					mdlBtn:SetText("Character")
					lmbBtn:SetText("Limbs")

					mdlBtn:SetFont("prSmallMenuBtnFont")
					lmbBtn:SetFont("prSmallMenuBtnFont")

					mdlBtn.Paint = buttonSkin
					lmbBtn.Paint = buttonSkin

					mdlBtn:SetWide(mdlBtnW)
					lmbBtn:SetWide(mdlBtnW)

					mdlBtn:DockMargin(0, 0, 2, 0)
					
					local lBarW = container.leftBar:GetWide()
					modelRow:DockPadding((lBarW - mdlBtnW*2)/2, 2, (lBarW - mdlBtnW*2)/2 + 2, 2)




					local displayPanel = container.leftBar:Add("Panel")
					displayPanel:Dock(FILL)

					container.model = vgui.Create("ixModelPanel", container.leftBar)
					container.model:Dock(FILL)
					container.model:SetModel(ply:GetModel())
					container.model:SetFOV(28)
					local modelEnt = container.model:GetEntity()
					modelEnt:SetSkin(ply:GetSkin())
					local plyBodygroups = ply:GetBodyGroups()
					
					for k, v in ipairs(plyBodygroups) do
						modelEnt:SetBodygroup(v.id, ply:GetBodygroup(v.id))
					end
					container.model:GetEntity():SetBodyGroups(ply:GetBodyGroups())
					local lookAt = container.model:GetLookAt()
					--container.model:SetCamPos(container.model:GetCamPos() + Vector(0, 0, -10))
					container.model:SetLookAt(lookAt + Vector(0, 0, -3))

					local displayMdl = container.model:GetEntity()
					if displayMdl and displayMdl:LookupAttachment( "eyes" ) > 0 then
						container.model:GetEntity():SetEyeTarget(displayMdl:GetAttachment( displayMdl:LookupAttachment( "eyes" ) ).Pos + displayMdl:GetForward()*64 )
					end

					if ix.gui.ModelPanelSelection == "model" then
						container.limbPnl:Hide()
					elseif ix.gui.ModelPanelSelection == "limb" then
						container.model:Hide()
					else
						ix.gui.ModelPanelSelection = "model"
						container.limbPnl:Hide()
					end
			
					container.nameLbl = vgui.Create("ixLabel", container.middleBar)
					container.nameLbl:SetFont("ixCharNameFont")
					container.nameLbl:SetText(char:GetName())
					container.nameLbl:SetContentAlignment(5)
					container.nameLbl:SetScaleWidth(true)
					container.nameLbl:SetPadding(container.middleBar:GetWide()/20)
					container.nameLbl:SetTall(ScrH()/20)
					container.nameLbl:Dock(TOP)
					container.nameLbl:DockMargin(0, 0, 0, ScrH()/100)
					container.nameLbl:SizeToContentsY()
					local totalHeight = 0
					totalHeight = totalHeight + ScrH()/100 + container.nameLbl:GetTall() + barPadding
			
					container.shortDescLbl = vgui.Create("ixLabel", container.middleBar)
					container.shortDescLbl:Dock(TOP)
					container.shortDescLbl:SetContentAlignment(4)
					container.shortDescLbl:SetTall(24)
					container.shortDescLbl:DockMargin(0, 0, 0, 0)
					container.shortDescLbl:SetFont("prSmallHeadingFont")
					container.shortDescLbl:SetText("Description")
					totalHeight = totalHeight + container.shortDescLbl:GetTall()
			
					container.shortDescPnl = vgui.Create("DPanel", container.middleBar)
					container.shortDescPnl:Dock(TOP)
					container.shortDescPnl:SetTall(19)
					container.shortDescPnl:SetText("Description")
					container.shortDescPnl:DockMargin(0, 5, 0, 0)
					totalHeight = totalHeight + container.shortDescPnl:GetTall() + 5
			
					container.shortDesc = vgui.Create("DTextEntry", container.shortDescPnl)
					container.shortDesc:Dock(FILL)
					container.shortDesc:SetFont("DermaDefault")
					container.shortDesc:SetText(char:GetDescription())
					container.shortDesc:SetContentAlignment(4)
					container.shortDesc:SetPaintBackground(false)
					container.shortDesc:SetTextColor(color_white)
			
					container.fullDescLbl = vgui.Create("ixLabel", container.middleBar)
					container.fullDescLbl:Dock(TOP)
					container.fullDescLbl:SetContentAlignment(4)
					container.fullDescLbl:SetTall(24)
					container.fullDescLbl:DockMargin(0, ScrH()/50, 0, 0)
					container.fullDescLbl:SetFont("prSmallHeadingFont")
					container.fullDescLbl:SetText("Extended Description")
			
					container.fullDescPnl = vgui.Create("DPanel", container.middleBar)
					container.fullDescPnl:Dock(TOP)
					container.fullDescPnl:DockMargin(0, 5, 0, 0)
					container.fullDescPnl:SetSize(10, ScrH()/7)
					container.fullDescPnl:DockPadding(0, 0, 0, 0)
			
					totalHeight = totalHeight + container.fullDescLbl:GetTall() + 5
			
					container.extDesc = vgui.Create("ixTextEntry", container.fullDescPnl)
					container.extDesc:Dock(FILL)
					container.extDesc:SetMultiline(true)
					container.extDesc:SetEnabled(false)
					container.extDesc:SetContentAlignment(7)
					container.extDesc:SetBackgroundColor(Color(82, 82, 82, 0, 5))
					container.extDesc:SetText(char:GetDescription())
					container.extDesc:SetFont("DermaDefault")
			
					container.charVars = vgui.Create("Panel", container.middleBar)
					container.charVars:SetTall((25 + 12)*4 + 12)
			
					if isCitizen then
						container.charVars:SetTall((25 + 12)*5 + 12)
					end 
			
					container.charVars:Dock(TOP)
					
					container.charVars:DockMargin(0, container.middleBar:GetWide()/100, 0, 0)
					container.charVars:DockPadding(0, 0, 0, 0)
					container.charVars:SetWide(container.middleBar:GetWide() - barPadding*2)
			
					-- Character Variable stuff
					do
			
						local iconBarW = 25
						
						local varBarW = (container.charVars:GetWide() - iconBarW - container.charVars:GetWide()/75)/2
			
						local varIcons = vgui.Create("Panel", container.charVars)
						varIcons:SetWide(iconBarW)
						varIcons:Dock(LEFT)
						varIcons:DockMargin(0, 0, container.charVars:GetWide()/75, 0)
			
						local varNames = vgui.Create("Panel", container.charVars)
						varNames:SetSize(varBarW, container.charVars:GetTall())
						varNames:Dock(LEFT)
					
						local varVals = vgui.Create("Panel", container.charVars)
						varVals:SetSize(varBarW, container.charVars:GetTall())
						varVals:Dock(LEFT)

						container.fields = {}
			
						for key, data in pairs(fields) do
							
							local icon = vgui.Create("ixLabel", varIcons)
							icon:Dock(TOP)
							icon:SetFont("ixPRIconsField")
							icon:SetText(data.icon)
							icon:DockMargin(0, 12, 0, 0)
							icon:SetContentAlignment(5)
							icon:SizeToContents()

			
							local lbl = vgui.Create("ixLabel", varNames)
							lbl:Dock(TOP)
							lbl:SetFont("prFieldsMenuThickFont")
							lbl:SetText(data.title)
							lbl:DockMargin(0, 12, 0, 0)
							lbl:SetContentAlignment(4)
			
							local val = vgui.Create("ixLabel", varVals)
							val:Dock(TOP)
							val:SetFont("prFieldsMenuFont")
							val:SetText(data.value)
							val:DockMargin(0, 12, 0, 0)
							val:SetContentAlignment(6)

							container.fields[key] = val
						end
					end
			
					totalHeight = totalHeight + container.charVars:GetTall() + container.middleBar:GetWide()/100
			
					local attribLbl = vgui.Create("ixLabel", container.middleBar)
					attribLbl:Dock(TOP)
					attribLbl:SetText("Attributes")
					attribLbl:SetContentAlignment(4)
					attribLbl:DockMargin(0, 5, 0, 0)
					attribLbl:SetFont("prSmallHeadingFont")
					attribLbl:SizeToContents()
					totalHeight = totalHeight + 5 + attribLbl:GetTall()
			
					local attribPnl = vgui.Create("Panel", container.middleBar)
					attribPnl:Dock(TOP)
					attribPnl:DockMargin(0, 0, 0, 0)
					attribPnl:SetSize(container.middleBar:GetWide(), ScrH()/3)
					attribPnl:DockPadding(0, 0, 0, 0)
			
					-- attribute stuff
					do
						local attrMargin = barPadding
			
						local attrH = container.middleBar:GetTall()/12
						local attrHeadingH = container.middleBar:GetTall()/30
			
						local attrLeft = vgui.Create("Panel", attribPnl)
						attrLeft:SetSize((attribPnl:GetWide() - barPadding*2)/2 + 1, attribPnl:GetTall())
						attrLeft:Dock(LEFT)
						attrLeft:DockPadding(0, 0, barPadding, 0)
					
						local attrRight = vgui.Create("Panel", attribPnl)
						attrRight:SetSize((attribPnl:GetWide() - barPadding*2)/2 + 1, attribPnl:GetTall())
						attrRight:Dock(RIGHT)
			
						local boosts = {}
						local vals = {}
						local charBoosts = char:GetBoosts()
			
						for k, v in pairs(char:GetAttributes()) do
							vals[k] = v
			
							local attrBoosts = charBoosts[k]
							if attrBoosts == nil then boosts[k] = 0 else
								local boostSum = 0
								for _, value in pairs(attrBoosts) do
									boostSum = boostSum + value
								end
			
								if boostSum == 0 then
									boosts[k] = 0
								else
									boosts[k] = boostSum/math.abs(boostSum)
								end
							end 
						end
			
						local posColor = Color(82, 204, 82)
						local negColor = Color(204, 82, 82)
			
						-- this solution is bad and you should feel bad
						-- local attrName = ix.attributes.list[v].name or "Undefined"
						local attribs = {"strength", "constitution", "intelligence", "agility"}
						local attribNames = {"Strength", "Constitution", "Intelligence", "Agility"}
			
						for k, v in ipairs(attribs) do
							local pnl = vgui.Create("DPanel")
							if k%2 == 0 then
								pnl:SetParent(attrLeft)
							else
								pnl:SetParent(attrRight)
							end
							pnl:Dock(TOP)
							pnl:DockMargin(0, 0, 0, attrMargin)
							
							pnl:SetSize(pnl:GetParent():GetWide(), attrH)
			
							local lbl = vgui.Create("ixLabel", pnl)
							lbl:Dock(TOP)
							lbl:SetText(attribNames[k])	
							lbl:SetTall(attrHeadingH)
							lbl:SetFont("prSmallMenuFont")
							lbl:SetContentAlignment(5)
			
							local val = vgui.Create("ixLabel", pnl)
							val:Dock(TOP)
							val:SetText(char:GetAttribute(v, 5))
							val:SetFont("prMediumMenuFont")
							val:SetContentAlignment(2)
							val:SetTall(attrH - attrHeadingH)
						end
			
						attribPnl:SetTall(attrH*2 + attrMargin*2)
			
					end
			
					totalHeight = totalHeight + attribPnl:GetTall() + 7
			
					container.fullDescPnl:SetTall(container.middleBar:GetTall() - totalHeight - barPadding)
				end
			
				-- Right Bar
				do
					local totalW = container.rightBar:GetWide()
					local totalH = container.rightBar:GetTall()
					local colMargin = 2
			
					local invPanel = container.rightBar:Add("Panel")
					invPanel:Dock(BOTTOM)
					invPanel:DockMargin(0, totalW/60, 0, 0)
					invPanel:SetSize(itemIconSize*6 + colMargin*4, itemIconSize*4 + colMargin*5)
			
					local canvas = invPanel:Add("DTileLayout")
					local canvasLayout = canvas.PerformLayout
					canvas.PerformLayout = nil -- we'll layout after we add the panels instead of each time one is added
					canvas:SetBorder(0)
					canvas:SetSpaceX(2)
					canvas:SetSpaceY(2)
					
					canvas:Dock(FILL)
			
					ix.gui.menuInventoryContainer = container:GetParent()	
			
					local panel = canvas:Add("prInventory")
					panel:InvalidateParent(true)
					panel:SetTitle(nil)
					panel.bNoBackgroundBlur = true
					panel:SetIconSize(itemIconSize)
					panel:SetDraggable(false)
					panel:SetSizable(false)
			
					local inventory = LocalPlayer():GetCharacter():GetInventory()

					if (inventory) then
						
						panel:SetInventory(inventory, false)
					end

					ix.gui.inv1 = panel
			
					if (ix.option.Get("openBags", true)) then
						for _, v in pairs(inventory:GetItems()) do
							if (!v.isBag) then
								continue
							end
			
							v.functions.View.OnClick(v)
						end
					end
			
					canvas.PerformLayout = canvasLayout
					canvas:Layout()
			
					canvas:SetSize(invPanel:GetSize())
					panel:SetSize(canvas:GetSize())
					
					local dataPanel = container.rightBar:Add("Panel")
					dataPanel:Dock(BOTTOM)
					dataPanel:SetSize(container.rightBar:GetWide() - totalW/30, totalH - invPanel:GetTall() - barPadding*3)
					dataPanel:DockMargin(0, 0, 0, 0)
			
					local dataBtnBar = dataPanel:Add("Panel")
					dataBtnBar:Dock(TOP)
					dataBtnBar:DockMargin(0, 0, 0, 5)
					dataBtnBar:SetTall(ScrH()/35)

					-- The text is drawn in the button by default, and I'm not sure why.
					--Color(145, 65, 45, 255)
					local buttonColor = Color(96, 38, 25, 255)
					local buttonSkin = function(panel, w, h)
						surface.SetDrawColor(buttonColor)
						surface.DrawRect(0, 0, w, h)

						surface.SetDrawColor(0, 0, 0)
						surface.DrawOutlinedRect(0, 0, w, h, 1)
						
						if ix.gui.CharDataSelection != nil and panel.dataType != nil and ix.gui.CharDataSelection == panel.dataType then
							surface.SetDrawColor(0, 0, 0, 100)
							surface.DrawRect(0, 0, w, h)
						end

						if panel:IsHovered() then
							surface.SetDrawColor(0, 0, 0, 50)
							surface.DrawRect(0, 0, w, h)
						end
					end
			
					local statusList = dataPanel:Add("DScrollPanel")
					statusList:Dock(TOP)
					statusList:SetTall(dataPanel:GetTall() - dataBtnBar:GetTall() - 5)
					statusList.PaintOver = function(panel, w, h)
						surface.SetDrawColor(0, 0, 0)
						local cW, cH = panel:GetCanvas():GetSize()
						surface.DrawOutlinedRect(0, 0, panel:GetWide() - panel:GetVBar():GetWide() + 1, panel:GetTall(), 2)
					end
					statusList.Paint = function(panel, w, h)
						local children = panel:GetCanvas():GetChildren()
						if panel.empty then return end
						local childrenH = #children*(totalW/15)
						if childrenH < h then
							surface.SetDrawColor(44, 44, 44, 105)
							surface.DrawRect(0, childrenH, w - 15, h - childrenH)

							surface.SetDrawColor(0, 0, 0, 150)

							surface.DrawRect(0, childrenH, w - 15, 1)
						end
					end
					
					statusList:SetSize(dataPanel:GetWide(), dataPanel:GetTall() - dataBtnBar:GetTall() - 5)

					local function PopulatePerks()
						local perks = char:GetData("perks", {})
						local i = 0
						local width
						statusList.empty = false

						if #perks*(totalW/15) > statusList:GetTall() then
							statusList:GetCanvas():DockPadding(0, 0, 0, 0)
						else	
							statusList:GetCanvas():DockPadding(0, 0, 15, 0)
						end
						for k, v in ipairs(perks) do
							i = i + 1
							local perkTable = ix.perks.list[v]
							local prk = vgui.Create("ixPerkDisplay")
							prk:SetTall(totalW/15)
							prk:SetName(perkTable.name)
							prk:SetDescription(perkTable.description)
							statusList:AddItem(prk)
							prk:Dock(TOP)
							

							prk:SetHelixTooltip(function(tooltip)
								local name = tooltip:AddRow("name")
								name:SetImportant()
								name:SetText(perkTable.name)
								name:SizeToContents()
	
								local desc = tooltip:AddRow("description")
								desc:SetText(perkTable.description)
								desc:SizeToContents()
							end)
							
				
							if i%2 == 0 then prk:SetBackgroundColor(Color(54, 54, 54, 103)) end
						end

						if #perks == 0 then
							statusList.empty = true
							local emptyLbl = statusList:Add("ixLabel")
							local labelW = container.rightBar:GetWide() - totalW/30 - 1
							emptyLbl:SetSize(labelW, statusList:GetTall())
							emptyLbl:SetBackgroundColor(Color(54, 54, 54, 103))
							emptyLbl:SetContentAlignment(5)
							emptyLbl:SetText("You have no perks!")
							emptyLbl:SetFont("prSmallMenuFont")
						end

						
					end

					local function PopulateEffects()
						local charEffects = char:GetEffects()

						if #charEffects*(totalW/15) > statusList:GetTall() then
							statusList:GetCanvas():DockPadding(0, 0, 0, 0)
						else	
							statusList:GetCanvas():DockPadding(0, 0, 15, 0)
						end

						statusList.empty = false

						if #charEffects == 0 then
							statusList.empty = true
							local emptyLbl = statusList:Add("ixLabel")
							local labelW = container.rightBar:GetWide() - totalW/30 - 1

							emptyLbl:SetSize( labelW, statusList:GetTall())
							emptyLbl:SetBackgroundColor(Color(54, 54, 54, 103))
							emptyLbl:SetContentAlignment(5)
							emptyLbl:SetText("You have no effects!")
							emptyLbl:SetFont("prSmallMenuFont")
						else
							table.SortByMember(charEffects, "Time")
						end

						for effID, instanceData in pairs(charEffects) do
							local effectTbl = ix.effects.list[effID]
							local eff = vgui.Create("ixEffectDisplay")
							eff:SetName(effectTbl.name)
							statusList:AddItem(eff)
							eff:Dock(TOP)
							eff:SetTall(totalW/10) 
							eff:SetSize(statusList:GetWide(), totalW/15)

							for attribID, value in pairs(effectTbl.attribs) do
								eff:AddEffect(ix.skills.list[attribID].name, value)
							end

							for skillID, value in pairs(effectTbl.skills) do
								eff:AddEffect(ix.skills.list[skillID].name, value)
							end

							
				
							if i%2 == 0 then eff:SetBackgroundColor(Color(54, 54, 54, 103)) end
						end
					end

					local function PopulateSkills()
						local skills = char:GetSkills() or {}
			
						local i = 0

						statusList.empty = false

						if table.Count(skills)*(totalW/15) > statusList:GetTall() then
							statusList:GetCanvas():DockPadding(0, 0, 0, 0)
						else	
							statusList:GetCanvas():DockPadding(0, 0, 15, 0)
						end

						for i, v in pairs(ix.skills.listSorted) do
							i = i + 1
					
							local skillTable = ix.skills.listSorted[i]
							k = v.uniqueID
							local skl = vgui.Create("ixSkillDisplay")
							skl:SetName(v.name)
							statusList:AddItem(skl)
							skl:Dock(TOP)
							skl:SetTall(totalW/15) 
								
							skl:SetValue(math.floor(char:GetSkill(k)))

							skl:SetHelixTooltip(function(tooltip)
								local name = tooltip:AddRow("name")
								name:SetImportant()
								name:SetText(v.name)
								name:SizeToContents()

								local desc = tooltip:AddRow("description")
								desc:SetText(v.description)
								desc:SizeToContents()
							end)

							if i%2 == 0 then skl:SetBackgroundColor(Color(54, 54, 54, 103)) end
						end
					end

					local buttonClick = function(panel)
						if ix.gui.CharDataSelection != panel.dataType then
							statusList:Clear()
							
							if panel.dataType == "perks" then
								PopulatePerks()
							elseif panel.dataType == "effects" then
								PopulateEffects()
							else
								PopulateSkills()
							end

							ix.gui.CharDataSelection = panel.dataType
						end
					end	


					local skillsBtn = dataBtnBar:Add("DButton")
					skillsBtn:Dock(LEFT)
					skillsBtn:SetWide(ScrW()/20)
					skillsBtn:DockMargin(0, 0, 5, 0)
					skillsBtn:SetText("Skills")
					skillsBtn:SetFont("prSmallMenuBtnFont")
					skillsBtn.Paint = buttonSkin
					skillsBtn.DoClick = buttonClick
					skillsBtn.dataType = "skills"

					
					local perksBtn = dataBtnBar:Add("DButton")
					perksBtn:Dock(LEFT)
					perksBtn:SetWide(ScrW()/20)
					perksBtn:DockMargin(0, 0, 5, 0)
					perksBtn:SetText("Perks")
					perksBtn:SetFont("prSmallMenuBtnFont")
					perksBtn.Paint = buttonSkin
					perksBtn.DoClick = buttonClick
					perksBtn.dataType = "perks"

					local effectsBtn = dataBtnBar:Add("DButton")
					effectsBtn:Dock(LEFT)
					effectsBtn:SetWide(ScrW()/20)
					effectsBtn:SetText("Effects")
					effectsBtn:SetFont("prSmallMenuBtnFont")
					effectsBtn.Paint = buttonSkin
					effectsBtn.DoClick = buttonClick
					effectsBtn.dataType = "effects"

					if !ix.gui.CharDataSelection then
						ix.gui.CharDataSelection = "skills"
					end

					if ix.gui.CharDataSelection == "perks" then
						PopulatePerks()
					elseif ix.gui.CharDataSelection == "effects" then
						PopulateEffects()
					else
						PopulateSkills()
					end
				end
				
			end
		end
	}

	
end)

PANEL = {}
AccessorFunc(PANEL, "name", "Name", FORCE_STRING)
AccessorFunc(PANEL, "effects", "Effects")

function PANEL:Init()
	self.nameLbl = self:Add("ixLabel")
	self.nameLbl:Dock(LEFT)
	self.nameLbl:SetWide(ScrW()/15)
	self.nameLbl:SetContentAlignment(5)
	self.nameLbl:SetFont("prSmallMenuFont")

	self.effectsPanel = self:Add("Panel")
	self.effectsPanel:Dock(LEFT)
	self.effectsPanel:DockMargin(0, 0, 0, 0)
	
	self.effects = {}
	self.effectLabels = {}
end 

-- @string effect The attribute or skill affected.
-- @number amount The amount decreased or increased for the attribute or skill.
function PANEL:AddEffect(effect, amount)
	self.effects[#self.effects + 1] = {
		["effect"] = effect,
		["amount"] = amount
	}
	self:SetupEffects()
end

function PANEL:SetEffects(effects)
	self.effects = effects 
	self:SetupEffects()
end

function PANEL:SetupEffects()
	self.effectLabels = {}

	for k, v in ipairs(self.effectsPanel:GetChildren()) do
		v:Remove()
	end

	local openWidth = self.effectsPanel:GetWide() - (#self.effects - 1)*ScrW()/75

	for k, v in ipairs(self.effects) do
		local eff = self.effectsPanel:Add("ixLabel")
		eff:SetContentAlignment(5)
		eff:Dock(LEFT)
		eff:SetFont("prSmallMenuFont")
		eff:SetText(v.effect.. " "..(v.amount > 0 and "+"..v.amount or v.amount))
		eff:SetWide(openWidth/#self.effects)
		if k != #self.effects then
			eff:DockMargin(0, 0, ScrW()/75, 0)
		end
	end
end

function PANEL:OnSizeChanged(newW, newH)
	self.effectsPanel:SetWide(newW - self.nameLbl:GetWide())
	--self.hoverGuard:SetSize(newW, newH)
end

function PANEL:SetName(name)
	self.name = name
	self.nameLbl:SetText(name)

	self.effectsPanel:SetWide(self.nameLbl:GetWide() - ScrW()/100)
end

vgui.Register("ixEffectDisplay", PANEL, "DPanel")

PANEL = {}
AccessorFunc(PANEL, "name", "Name", FORCE_STRING)
AccessorFunc(PANEL, "description", "Description")

function PANEL:Init()
	self.nameLbl = self:Add("ixLabel")
	self.nameLbl:Dock(FILL)
	self.nameLbl:SetContentAlignment(5)
	--self.nameLbl:SetWide(ScrW()/15)
	self.nameLbl:SetFont("prSmallMenuFont")

	self.hoverGuard = self:Add("Panel")
	self.hoverGuard:SetZPos(999)
	self.hoverGuard:SetSize(self:GetSize())

	/*

	self.descLbl = self:Add("ixLabel")
	self.descLbl:Dock(FILL)
	self.descLbl:SetContentAlignment(5)
	self.descLbl:SetFont("prSmallMenuFont")

	*/
end

function PANEL:SetName(name)
	self.name = name
	self.nameLbl:SetText(name)
	self.hoverGuard:SetZPos(999)
	self.hoverGuard:SetSize(self:GetSize())
end


function PANEL:SetDescription(desc)
	self.description = desc
	--self.descLbl:SetText(desc)
end

function PANEL:SetHelixTooltip(tooltip)
	self.hoverGuard:SetHelixTooltip(tooltip)
end

function PANEL:OnSizeChanged(w, h)
	self.hoverGuard:SetSize(w, h)
end

vgui.Register("ixPerkDisplay", PANEL, "DPanel")

PANEL = {}
AccessorFunc(PANEL, "name", "Name", FORCE_STRING)
AccessorFunc(PANEL, "value", "Value")

function PANEL:Init()
	self.nameLbl = self:Add("ixLabel")
	self.nameLbl:Dock(LEFT)
	self.nameLbl:SetContentAlignment(4)
	self.nameLbl:SetWide(ScrW()/15)
	self.nameLbl:DockMargin(ScrW()/100, 0, 0, 0)
	self.nameLbl:SetFont("prSmallMenuFont")

	self.valLbl = self:Add("ixLabel")
	self.valLbl:Dock(FILL)
	self.valLbl:SetContentAlignment(6)
	self.valLbl:DockMargin(0, 0, ScrW()/100, 0)
	self.valLbl:SetFont("ixMenuMiniFont")
	self.valLbl:SetFont("prSmallMenuFont")

	self.hoverGuard = self:Add("Panel")
	self.hoverGuard:SetZPos(999)
	self.hoverGuard:SetSize(self:GetSize())
end

function PANEL:SetName(name)
	self.name = name
	self.nameLbl:SetText(name)
	self.hoverGuard:SetZPos(999)
	self.hoverGuard:SetSize(self:GetSize())
end

function PANEL:SetValue(val)
	self.value = desc
	self.valLbl:SetText(val)
	self.hoverGuard:SetZPos(999)
	self.hoverGuard:SetSize(self:GetSize())
end

function PANEL:SetHelixTooltip(tooltip)
	self.hoverGuard:SetHelixTooltip(tooltip)
end

function PANEL:OnSizeChanged(w, h)
	self.hoverGuard:SetSize(w, h)
end

vgui.Register("ixSkillDisplay", PANEL, "DPanel")