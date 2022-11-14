
local padding = ScreenScale(32)

-- create character panel
DEFINE_BASECLASS("prMenu")
local PANEL = {}

local gradientRadial = Material("helix/gui/radial-gradient.png")

function PANEL:Init()
	local parent = self:GetParent()
	local halfWidth = parent:GetWide() * 0.5 - (padding * 2)
	local halfHeight = parent:GetTall() * 0.5 - (padding * 2)
	local modelFOV = (ScrW() > ScrH() * 1.8) and 100 or 78

	self.notice = self:Add("ixNoticeBar")

	self.currentDimAmount = 0
	self.currentY = 0
	self.currentScale = 1
	self.currentAlpha = 0
	self.targetDimAmount = 255
	self.targetScale = 0.9

	self.charButton = self.navbar:Add("DButton")
	self.charButton:SetTall(ScrH()/15)

	self.charButton:SetText("Return to Main Menu")
	self.charButton:SetFont("prCategoryHeadingFont")
	self.charButton:Dock(BOTTOM)
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
	
	self.charButton.DoClick = function(panel)
		self:GetParent().mainPanel:Show()
		timer.Simple(0, function()
			self:Remove()
		end)
		
	end

	self:SetNavbarDock(LEFT)
	self:SetNavbarSize(300)
	self:SetAnimationTime(0.25)

	local gradient = Material("vgui/gradient-d")

	self:ResetPayload()
	

	self.factionButtons = {}
	self.repopulatePanels = {}

	self:SetupSubpanels()

	-- setup character creation hooks
	net.Receive("ixCharacterAuthed", function()
		timer.Remove("ixCharacterCreateTimeout")
		self.awaitingResponse = false

		local id = net.ReadUInt(32)
		local indices = net.ReadUInt(6)
		local charList = {}

		for _ = 1, indices do
			charList[#charList + 1] = net.ReadUInt(32)
		end

		ix.characters = charList

		if (!IsValid(self) or !IsValid(parent)) then
			return
		end

		if (LocalPlayer():GetCharacter()) then
			self:GetParent():ShowNotice(2, L("charCreated"))
			self:GetParent().mainPanel:Show()
			timer.Simple(0, function()
				self:Remove()
			end)
		elseif (id) then
			self.bMenuShouldClose = true

			net.Start("ixCharacterChoose")
				net.WriteUInt(id, 32)
			net.SendToServer()
		else
		end
	end)

	net.Receive("ixCharacterAuthFailed", function()
		timer.Remove("ixCharacterCreateTimeout")
		self.awaitingResponse = false

		local fault = net.ReadString()
		local args = net.ReadTable()

		self:ShowNotice(3, L(fault, unpack(args)))
	end)

	self.notice:SetZPos(999)
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(33, 33, 33)
	surface.DrawRect(0, 0, w, h)
end

function PANEL:OnNavButtonClick(button, subpanelID)
	if subpanelID != "faction" then
		if self.payload.faction == nil then
			self:ShowNotice(3, "You have not picked a faction yet!")
			return false
		end
	end
	return true
end

function PANEL:SetupSubpanels()
	local subpanels = {
		[1] = {
			name = "Appearance",
			index = "appearance",
			populate = function(subpanel)
				local panel = subpanel:Add("DPanel")
				panel:Dock(FILL)
				panel.Paint = function(panel, w, h)
					surface.SetDrawColor(44, 44, 44)
					surface.DrawRect(0, 0, w, h)
				end

				local imgMat = Material("gui/ps_hover.png")

				local skinLbl
				local eyeColorLbl
				local eyeColorSelect
				local suitLblPanel
				local suitLbl
				local suitList

				local infoPanel = panel:Add("DScrollPanel")
				
				infoPanel:Dock(FILL)
				infoPanel:DockMargin(10, ScrH()/10, 10, ScrH()/10)

				subpanel.faction = self.payload.faction.index

				self.payload.faction.models = self.payload.faction:GetModels(LocalPlayer())

				subpanel.model = panel:Add("ixModelPanel")		
				subpanel.model:Dock(LEFT)

				local defaultCamPos = subpanel.model:GetCamPos()
				local defaultLookAt = subpanel.model:GetLookAt()
				
				local nameLbl = infoPanel:Add("DLabel")
				nameLbl:SetText("Name")
				nameLbl:Dock(TOP)
				nameLbl:SetFont("prMenuButtonLabelFont")
				nameLbl:SizeToContents()
				infoPanel:AddItem(nameLbl)

				local namePanel = infoPanel:Add("Panel")
				namePanel:Dock(TOP)
				namePanel:SetTall(35)
				infoPanel:AddItem(namePanel)

				local nameEntry = namePanel:Add("ixTextEntry")
				nameEntry:Dock(FILL)
				nameEntry:SetFont("prMenuButtonFont")

				local descLbl = infoPanel:Add("DLabel")
				descLbl:SetText("Description")
				descLbl:DockMargin(0, 40, 0, 0)
				descLbl:Dock(TOP)
				descLbl:SetFont("prMenuButtonLabelFont")
				descLbl:SizeToContents()
				infoPanel:AddItem(descLbl)

				local descPanel = infoPanel:Add("Panel")
				descPanel:Dock(TOP)
				descPanel:SetTall(35)
				infoPanel:AddItem(descPanel)

				local descEntry = descPanel:Add("ixTextEntry")
				descEntry:Dock(FILL)
				descEntry:SetFont("prMenuButtonFont")
				descEntry:SetUpdateOnType(true)
				descEntry.OnValueChange = function(panel, value)
					self.payload.description = value
				end

				local modelLbl = infoPanel:Add("DLabel")
				modelLbl:SetText("Model")
				modelLbl:DockMargin(0, 40, 0, 0)
				modelLbl:Dock(TOP)
				modelLbl:SetFont("prMenuButtonLabelFont")
				modelLbl:SizeToContents()
				infoPanel:AddItem(modelLbl)

				local modelList = infoPanel:Add("DGrid")
				modelList:Dock(TOP)
				modelList.Paint = function(panel, w, h)
					surface.SetDrawColor(101, 101, 101)
					surface.DrawRect(0, 0, w, h)
				end
				modelList:Show()
				modelList:SetColWide(64)
				modelList:SetRowHeight(64)
				modelList:SetCols(20)

				timer.Simple(0, function()
					modelList:SetWide(64*17)
				end)
				
				infoPanel:AddItem(modelList)

				local function ModelSetup(model)
					if skinLbl then
						skinLbl:Remove()
						eyeColorLbl:Remove()
						eyeColorSelect:Remove()
						infoPanel.skinSlider:Remove()
					end

					if suitLbl then
						suitLbl:Remove()
						suitLblPanel:Remove()
						suitHelp:Remove()
						suitList:Remove()
					end

					self.payload.model = model

					subpanel.model:SetModel(self.payload.model)

					local modelEntity = subpanel.model:GetEntity()
					if modelEntity:LookupAttachment( "eyes" ) > 0 then
						local eyepos = modelEntity:GetAttachment( modelEntity:LookupAttachment( "eyes" ) ).Pos
						modelEntity:SetEyeTarget(eyepos + modelEntity:GetAttachment( modelEntity:LookupAttachment( "eyes" ) ).Pos + modelEntity:GetForward()*64 + modelEntity:GetRight() * -64 + modelEntity:GetUp()*-64)
					end

					if self.payload.faction.GetDefaultName then
						local name = self.payload.faction:GetDefaultName(LocalPlayer(), self.payload.model)
						self.payload.name = name
						if name != "" then
							nameEntry:SetText(name)
							nameEntry:SetEnabled(false)
						end
					end

					isCitizen = self.payload.faction.index == FACTION_CITIZEN
					isVort = model == "models/projectrevival/vortigaunt_mod.mdl"
					hasEyes = self.payload.faction.index == FACTION_CITIZEN or model == "models/projectrevival/vortigaunt_mod.mdl"
					hasSkins = self.payload.faction.index == FACTION_CITIZEN or model == "models/projectrevival/vortigaunt_mod.mdl"

					if isVort then
						modelEntity:SetBodygroup(1, 1)
					end

					if hasEyes then
						local modelEntity = subpanel.model:GetEntity() 
	
						if modelEntity:LookupAttachment("eyes") > 0 then
							local eyepos = modelEntity:GetAttachment(modelEntity:LookupAttachment("eyes")).Pos
							modelEntity:SetEyeTarget(eyepos + modelEntity:GetRight()*0 + modelEntity:GetForward()*22- modelEntity:GetUp())
						end
					end

					if hasEyes then
						skinLbl = infoPanel:Add("DLabel")
						skinLbl:SetText("Skin")
						skinLbl:DockMargin(0, 40, 0, 0)
						skinLbl:Dock(TOP)
						skinLbl:SetFont("prMenuButtonLabelFont")
						skinLbl:SizeToContents()
						infoPanel:AddItem(skinLbl)

						infoPanel.skinSlider = infoPanel:Add("ixNumSlider")
						infoPanel.skinSlider:Dock(TOP)
						infoPanel.skinSlider:SetMin(0)
						infoPanel.skinSlider:SetValue(0)
						infoPanel.skinSlider:SetDecimals(0)
						infoPanel.skinSlider:SetTall(35)
						infoPanel.skinSlider.segmented = true
						infoPanel:AddItem(infoPanel.skinSlider)

						eyeColorLbl = infoPanel:Add("DLabel")
						eyeColorLbl:SetText("Eye Color")
						eyeColorLbl:DockMargin(0, 40, 0, 0)
						eyeColorLbl:Dock(TOP)
						eyeColorLbl:SetFont("prMenuButtonLabelFont")
						eyeColorLbl:SizeToContents()
						infoPanel:AddItem(eyeColorLbl)

						eyeColorSelect = infoPanel:Add("DComboBox")
						eyeColorSelect:Dock(TOP)
						eyeColorSelect:SetSortItems(false)
						eyeColorSelect:SetTall(35)
						eyeColorSelect:SetFont("prMenuButtonFont")
						infoPanel:AddItem(eyeColorSelect)	

						if isCitizen then
							timer.Simple(0, function()
								infoPanel.skinSlider:SetMax(math.floor((NumModelSkins(self.payload.model) + 1)/3) - 1)
							end)
							
							eyeColorSelect:AddChoice("Brown")
							eyeColorSelect:AddChoice("Blue")
							eyeColorSelect:AddChoice("Green")

							suitLblPanel = infoPanel:Add("Panel")
							suitLblPanel:Dock(TOP)
							suitLblPanel:DockMargin(0, 40, 0, 0)
							infoPanel:AddItem(eyeColorSelect)
	
							suitLbl = suitLblPanel:Add("DLabel")
							suitLbl:SetText("Suit Style")
							suitLbl:Dock(LEFT)
							suitLbl:SetFont("prMenuButtonLabelFont")
							suitLbl:SizeToContents()
	
							suitLblPanel:SetTall(suitLbl:GetTall())
							
							suitHelp = suitLblPanel:Add("DLabel")
							suitHelp:Dock(LEFT)
							suitHelp:SetFont("DermaDefault")
							suitHelp:SetText("(?)")
							suitHelp:SizeToContents()
							suitHelp:SetTextColor(Color(170, 170, 170))
							suitHelp:DockMargin(5, 0, 0, -10)
							suitHelp:SetHelixTooltip(function(tooltip)
								local text = tooltip:AddRow("text")
								text:SetText("This is the default suit you spawn with. You can obtain a respirator and other suits once in the city.")
								text:SizeToContents()
							end)
							
	
							suitList = infoPanel:Add("DGrid")
							suitList:Dock(TOP)
							suitList.Paint = function(panel, w, h)
								surface.SetDrawColor(101, 101, 101)
								surface.DrawRect(0, 0, w, h)
							end
							suitList:Show()
							suitList:SetColWide(64)
							suitList:SetRowHeight(64)
							suitList:SetCols(12)
							infoPanel:AddItem(suitList)
	
							for k, v in pairs(DEFAULT_SUITS) do
								print("suit loop")
								local icon = self:Add("ixScoreboardIcon")
								icon:SetSize(64, 64)
								icon:SetModel(v)
								icon:SetVisible(true)
								
								local button = self:Add("DButton")
								button:SetParent(icon)
								button:Dock(FILL)
								button:SetText("")
								icon.button = button
								button.model = v
	
								button.Paint = function(panel, w, h)
									if self.payload.suit and string.Replace(self.payload.suit, "female", "male") == button.model then
										surface.SetMaterial(imgMat)
										surface.SetDrawColor( 255, 255, 255, 255 )
										surface.DrawTexturedRectUV(0, 0, w, h/2, 0, 0, 1, 0.8)
										surface.DrawTexturedRectUV(0, h/2, w, h/2, 0, 0.2, 1, 1)
									end
									if panel:IsHovered() and !subpanel.model.isDragging then
										surface.SetDrawColor(0, 0, 0, 50)
										surface.DrawRect(0, 0, w, h/2)
										if panel:IsDown() then
											surface.DrawRect(0, 0, w, h)
										end
									end
								end
	
								button.DoClick = function(panel)
									local model = panel.model
									if string.find(self.payload.model, "female") and string.find(panel.model, "male") then
										model = string.Replace(model, "male", "female")
									end
									self.payload.suit = model
	
									subpanel.model:SetModel(model)
								end

								suitList:AddItem(icon)
							end
	
							
						elseif isVort then
							infoPanel.skinSlider:SetMax(math.floor(30/6) - 1)

							eyeColorSelect:AddChoice("Red")
							eyeColorSelect:AddChoice("Blue")
							eyeColorSelect:AddChoice("Green")
							eyeColorSelect:AddChoice("Orange")
							eyeColorSelect:AddChoice("Pink")
							eyeColorSelect:AddChoice("Yellow")
						end

						eyeColorSelect:ChooseOptionID(1)

						function eyeColorSelect:OpenMenu()
							self:ixOpenMenu()
					
							if (IsValid(self.Menu)) then
								local _, y = self.Menu:LocalToScreen(self.Menu:GetPos())
					
								self.Menu:SetFont(self:GetFont())
								self.Menu:SetMaxHeight(ScrH() - y)
							end
						end
	
						function eyeColorSelect.Paint(panel, w, h)
							surface.SetDrawColor(derma.GetColor("DarkerBackground", self))
							surface.DrawRect(0, 0, w, h)
						end
	
						eyeColorSelect.OnMenuOpened = function(panel, dMenu)
							if IsValid(dMenu) then
								dMenu.Think = function(panel)
									local modelEnt = subpanel.model:GetEntity()
									local activeSkin = modelEnt:GetSkin()
									local expectedSkin
									if isCitizen then
										
										local eyeColor = math.floor(self.payload.skin/math.floor((NumModelSkins(self.payload.model) + 1)/3))
										if panel:GetChild(1):IsHovered()  then
											eyeColor = 0
										elseif panel:GetChild(2):IsHovered()then
											eyeColor = 1
										elseif panel:GetChild(3):IsHovered() then
											eyeColor = 2
										end
										
										expectedSkin = infoPanel.skinSlider:GetValue() + (eyeColor)*(math.floor((NumModelSkins(self.payload.model) + 1)/3))
										
									elseif isVort then
										local eyeColor = math.floor(self.payload.skin/5)
										if panel:GetChild(1):IsHovered()  then
											eyeColor = 0
										elseif panel:GetChild(2):IsHovered()then
											eyeColor = 1
										elseif panel:GetChild(3):IsHovered() then
											eyeColor = 2
										elseif panel:GetChild(4):IsHovered() then
											eyeColor = 3
										elseif panel:GetChild(5):IsHovered() then
											eyeColor = 4
										elseif panel:GetChild(6):IsHovered() then
											eyeColor = 5
										end
										
										expectedSkin = infoPanel.skinSlider:GetValue() + (eyeColor)*(math.floor(30/6)) 
									end

									if activeSkin != expectedSkin then 
										modelEnt:SetSkin(expectedSkin)
									end
								end
							end
	
							if !subpanel.model.eyeCloseup and isCitizen then
								local modelEnt = subpanel.model:GetEntity()
								subpanel.model.oldCamPos = subpanel.model:GetCamPos()
								subpanel.model.oldLookAt = subpanel.model:GetLookAt()
								subpanel.model.oldSequence = modelEnt:GetSequence()
								subpanel.model.oldSkin = modelEnt:GetSkin()
								subpanel.model.oldModel = subpanel.model:GetModel()
	
								subpanel.model.oldAngles = subpanel.model:GetEntity():GetAngles()
								subpanel.model:GetEntity():SetAngles(Angle(0, 45, 0))
								subpanel.model:SetModel(self.payload.model, infoPanel.skinSlider:GetValue() + (panel:GetSelectedID() - 1)*(math.floor((NumModelSkins(self.payload.model) + 1)/3)))
					
								
								subpanel.model.eyeCloseup = true
								local eyeOffset = Vector(-30, -35, 15)
								--timer.Simple(0, function()
									local modelEnt = subpanel.model:GetEntity()
									if modelEnt:LookupAttachment("eyes") > 0 and isCitizen then
										local eyepos = modelEnt:GetBonePosition(modelEnt:LookupAttachment("eyes"))
	
										--modelEnt:ResetSequence("ragdoll")
	
										eyepos:Add(Vector(0, 0, 1))	-- Move up slightly
	
										subpanel.model:SetLookAt(eyepos + modelEnt:GetRight()*0 + modelEnt:GetUp())
	
										subpanel.model:SetCamPos(eyepos + modelEnt:GetRight()*0 + modelEnt:GetForward()*22 + modelEnt:GetUp())
	
										--model:SetFOV(30)	-- Move cam in front of eyes
	
										modelEnt:SetEyeTarget(subpanel.model:GetCamPos())
									end
								--end)
							end
						end 
	
						eyeColorSelect.OnSelect = function(panel, index, value)
							subpanel.model.oldSkin = nil
							local realSkin
							if isCitizen then
								realSkin = infoPanel.skinSlider:GetValue() + (eyeColorSelect:GetSelectedID() - 1)*(math.floor((NumModelSkins(self.payload.model) + 1)/3))
							else
								realSkin = infoPanel.skinSlider:GetValue() + (eyeColorSelect:GetSelectedID() - 1)*(math.floor(30/6))
							end
							self.payload.skin = realSkin
							subpanel.model:GetEntity():SetSkin(realSkin)
						end

						eyeColorSelect.Think = function(panel)
							local hovered = eyeColorSelect:IsHovered() and !subpanel.model.isDragging
							local menuOpen = panel:IsMenuOpen()
							if hovered and !subpanel.model.eyeCloseup then
								panel.OnMenuOpened(panel)
							end
	
							if !menuOpen and !hovered and (subpanel.model:GetEntity():GetSkin() != self.payload.skin or subpanel.model.eyeCloseup) then
								if subpanel.model.eyeCloseup then
									subpanel.model:SetCamPos(subpanel.model.oldCamPos)
									subpanel.model:SetLookAt(subpanel.model.oldLookAt)
									subpanel.model.eyeCloseup = false
									subpanel.model:GetEntity():SetAngles(subpanel.model.oldAngles)
								end

								if isCitizen then
									subpanel.model:GetEntity():SetSkin(infoPanel.skinSlider:GetValue() + (panel:GetSelectedID() - 1)*(math.floor((NumModelSkins(self.payload.model) + 1)/3)))
								else
									subpanel.model:GetEntity():SetSkin(infoPanel.skinSlider:GetValue() + (panel:GetSelectedID() - 1)*(math.floor(30/6)))
								end
							end
						end
						
						infoPanel.skinSlider.OnValueUpdated = function(panel)
							subpanel.model.oldSkin = nil
							local realSkin
							if isCitizen then
								realSkin = panel:GetValue() + (eyeColorSelect:GetSelectedID() - 1)*(math.floor((NumModelSkins(self.payload.model) + 1)/3))
							else
								realSkin = panel:GetValue() + (eyeColorSelect:GetSelectedID() - 1)*(math.floor(30/6))
							end
	
							self.payload.skin = realSkin
							subpanel.model:GetEntity():SetSkin(realSkin)
						end

						function eyeColorSelect:OpenMenu()
							self:ixOpenMenu()
					
							if (IsValid(self.Menu)) then
								local _, y = self.Menu:LocalToScreen(self.Menu:GetPos())
					
								self.Menu:SetFont(self:GetFont())
								self.Menu:SetMaxHeight(ScrH() - y)
							end
						end
	
						function eyeColorSelect.Paint(panel, w, h)
							surface.SetDrawColor(derma.GetColor("DarkerBackground", self))
							surface.DrawRect(0, 0, w, h)
						end
					end

					local modelEntity = subpanel.model:GetEntity()

					
					print("MODEL", model)
					if model == "models/cdpmator.mdl" then
						subpanel.model:SetFOV(45)
						subpanel.model:SetCamPos(defaultCamPos - modelEntity:GetForward()*5 + modelEntity:GetUp()*20 +  modelEntity:GetRight()*15)

					else
						subpanel.model:SetFOV(28)
						subpanel.model:SetLookAt(defaultLookAt + Vector(0, 0, -3))
						subpanel.model:SetCamPos(defaultCamPos)
					end

					subpanel.model:SetWide(ScrW()/5)
					
				
					

				end

				function subpanel.model:Think()
					local mouseDown = input.IsMouseDown(MOUSE_LEFT)
					local isDown = self:IsHovered() and mouseDown

					if !self.isDragging and isDown then
						self.isDragging = true
						self:MouseCapture(true)
						self:SetCursor("blank")
						self.startingX = gui.MouseX()
						self.startingY = gui.MouseY()
						self.startingYaw = self:GetEntity():GetAngles().y
					elseif self.isDragging and !mouseDown then
						self.isDragging = false
						self:MouseCapture(false)
						self:SetCursor("hand")
						input.SetCursorPos(self.startingX, self.startingY)
					end

					if self.isDragging then
						local ent = self:GetEntity()

						local lookat = Vector( 0, 0, 0 )

						local mouseX = gui.MouseX()
						local mouseY = gui.MouseY()
						
						local yaw = (self.startingX - mouseX)%360


						if mouseX <= 0 or mouseX >= ScrW() - 1  then
							input.SetCursorPos(self.startingX - yaw, mouseY)
						end
						if ent:LookupAttachment( "eyes" ) > 0 then
							ent:SetEyeTarget( ent:GetAttachment( ent:LookupAttachment( "eyes" ) ).Pos + ent:GetForward()*20 )
							ent:SetAngles(Angle(0, self.startingYaw - yaw, 0))
						end
					end		
				end


				subpanel.model:SetCursor("hand")

				function subpanel:GetModel()
					return subpanel.model
				end

	
				nameEntry:SetUpdateOnType(true)

				nameEntry.OnValueChange = function(panel, value)
					self.payload.name = value
				end

				for k, v in ipairs(self.payload.faction.models or {}) do
					local icon = self:Add("ixScoreboardIcon")
					icon:SetSize(64, 64)
					icon:SetModel(v)
					icon:SetVisible(true)
					
					local button = self:Add("DButton")
					button:SetParent(icon)
					button:Dock(FILL)
					button:SetText("")
					icon.button = button
					button.model = v
					/*

					button.Think = function(panel)
						local hovered, color = panel:IsHovered(), panel:GetColor()
						if hovered and color.a == 0 then
							panel:SetColor(Color(255, 255, 255, 255))
						elseif !hovered and color.a == 255 then
							panel:SetColor(Color(255, 255, 255, 0))
						end
					end	

					*/

					button.Paint = function(panel, w, h)
						if self.payload.model == button.model then
							surface.SetMaterial(imgMat)
							surface.SetDrawColor( 255, 255, 255, 255 )
							surface.DrawTexturedRect(0, 0, w, h)
						end
						if panel:IsHovered() and !subpanel.model.isDragging then
							surface.SetDrawColor(0, 0, 0, 50)
							surface.DrawRect(0, 0, w, h)
							if panel:IsDown() then
								surface.DrawRect(0, 0, w, h)
							end
						end
					end

					button.DoClick = function(panel)
						print("MODELEWFGSDRV", panel.model)

						ModelSetup(panel.model)
					end

					if v == self.payload.model then
						button:DoClick(button)
					end

					modelList:AddItem(icon)
				end

				if self.payload.model == nil then
					local randModelTile = table.Random(modelList:GetItems())
					randModelTile.button:DoClick(randModelTile.button)
				end

				for k, v in ipairs(infoPanel:GetChildren()) do
					infoPanel:AddItem(v)
				end

				subpanel.populated = true
			end
		},
		[2] = {
			name = "Attributes",
			index = "attributes",
			populate = function(subpanel)
				local panel = subpanel:Add("DPanel")
				panel:Dock(FILL)
				panel.Paint = function(panel, w, h)
					surface.SetDrawColor(44, 44, 44)
					surface.DrawRect(0, 0, w, h)
				end

				local payload = self.payload

				panel:DockPadding(10, 0, 5, 0)

				local heading = panel:Add("DLabel")
				heading:Dock(TOP)
				heading:SetFont("ixCharNameFont")
				heading:SetText("Attributes")
				heading:SizeToContents()
				heading:DockMargin(0, 0, 0, -22)

				local subtitle = panel:Add("DLabel")
				subtitle:Dock(TOP)
				subtitle:SetFont("prSubTitleFont")
				subtitle:SetText("Allocate points to your character's attributes.")
				subtitle:SizeToContents()
				subtitle:DockMargin(0, 0, 0, -7)

				local explanation = panel:Add("DLabel")
				explanation:Dock(TOP)
				explanation:SetFont("prSubTitleFont")
				explanation:SetText("Attributes are measured from one to ten, where five is average, one is extremely below average, and ten is extremely above average.")
				explanation:SizeToContents()
				explanation:DockMargin(0, 0, 0, -7)

				local pointsLeft = panel:Add("DLabel")
				pointsLeft:Dock(TOP)
				pointsLeft:SetFont("prSubTitleFont")
				pointsLeft:SetText(ix.attributes.creationPoints.." Points Left")
				pointsLeft:SizeToContents()

				for k, v in pairs(ix.attributes.list) do
					payload.attributes[k] = payload.attributes[k] or 5
					local attribBar = panel:Add("prAttributeAdjust")
					attribBar:SetText(v.name)
					attribBar:SetDescription(v.description)
					attribBar:Dock(TOP)
					attribBar:DockMargin(0, 0, 0, 15)
					attribBar.uniqueID = k

					function attribBar:CanIncrease()
						local pointTotal = 0
						for uniqueID, attribVal in pairs(payload.attributes) do
							pointTotal = pointTotal + attribVal
						end

						return pointTotal < (ix.attributes.creationPoints + table.Count(ix.attributes.list)*5)
					end

					function attribBar:PostClick(change)
						
						payload.attributes[self.uniqueID] = (payload.attributes[self.uniqueID] or 5) + change

						local pointTotal = 0
						for uniqueID, attribVal in pairs(payload.attributes) do
				
							pointTotal = pointTotal + attribVal
						end

						local pointsLeftVal = ix.attributes.creationPoints + table.Count(ix.attributes.list)*5 - pointTotal

						if pointsLeftVal == 1 then
							pointsLeft:SetText(pointsLeftVal.." Point Left")
						else
							pointsLeft:SetText(pointsLeftVal.." Points Left")
						end
					end
				end

				subpanel.populated = true
			end
		},
		[3] = {
			name = "Skills",
			index = "skills",
			repopulateOnReopen = true,
			populate = function(subpanel)
				local panel = subpanel:Add("Panel")
				panel:Dock(FILL)
				panel.Paint = function(panel, w, h)
					--surface.SetDrawColor(116, 58, 43)
					surface.SetDrawColor(44, 44, 44)
					surface.DrawRect(0, 0, w, h)
				end

				panel:DockPadding(10, 0, 5, 0)

				local heading = panel:Add("DLabel")
				heading:Dock(TOP)
				heading:SetFont("ixCharNameFont")
				heading:SetText("Skills")
				heading:SizeToContents()
				heading:DockMargin(0, 0, 0, -22)

				local subtitle = panel:Add("DLabel")
				subtitle:Dock(TOP)
				subtitle:SetFont("prSubTitleFont")
				subtitle:SetText("Select up to three skills to have higher starting values.")
				subtitle:SizeToContents()
				subtitle:DockMargin(0, 0, 0, -7)

				local countLbl = panel:Add("DLabel")
				countLbl:Dock(TOP)
				countLbl:SetFont("prSubTitleFont")
				countLbl:SetText("2 Skills Left")
				countLbl:SizeToContents()

				local scrollPanel = panel:Add("DScrollPanel")
				scrollPanel:Dock(FILL)
				scrollPanel:DockMargin(0, 0, 0, 0)
				scrollPanel:GetCanvas():DockPadding(0, 10, 0, 10)

				local specChecks = {}
				local payload = self.payload

				for k, skillTbl in ipairs(ix.skills.listSorted) do
					local skillPnl = panel:Add("Panel")
					skillPnl:Dock(TOP)
					skillPnl:DockMargin(0, 0, 0, 15)
					skillPnl.skill = skillTbl.uniqueID
					
					scrollPanel:AddItem(skillPnl)

					local headerPnl = skillPnl:Add("DPanel")
					headerPnl:Dock(TOP)
					headerPnl:SetTall(40)
					--headerPnl:SetBackgroundColor(Color(32, 32, 32, 100))

					local header = headerPnl:Add("ixLabel")
					header:Dock(FILL)
					header:SetText(skillTbl.name)
					header:SetFont("prMenuButtonFontSmall")
					header:SizeToContents()
					header:SetContentAlignment(5)	

					local contentPnl = skillPnl:Add("Panel")
					contentPnl:Dock(FILL)
					contentPnl:DockPadding(5, 8, 5, 8)

					contentPnl.Paint = function(panel, w,  h)
						surface.SetDrawColor(20, 20, 20)
						surface.DrawOutlinedRect(0, -1, w, h + 1)
					end
					
					local desc = contentPnl:Add("DLabel")
					desc:Dock(TOP)
					desc:SetWrap(true)
					desc:SetFont("prToolTipText")
					desc:SetText(skillTbl.description)

					local boost = contentPnl:Add("DLabel")
					boost:Dock(TOP)
					boost:SetWrap(true)
					boost:SetFont("prToolTipText")
					boost:DockMargin(0, 8, 0, 0)
					boost:SetText((skillTbl.boosts.smallBoost == nil) and (" - Large boost from "..skillTbl.boosts.largeBoost..".") or (" - Large boost from "..skillTbl.boosts.largeBoost..", small boost from "..skillTbl.boosts.smallBoost.."."))

					local specCheck = contentPnl:Add("prCheckboxLabel")
					specCheck:Dock(TOP)
					specCheck:SetTall(30)
					specCheck:SetText("Specialize")
					specCheck:SetFont("prToolTipText")
				
					specCheck.skill = skillTbl.uniqueID

					function specCheck:CanChangeValue(value)
						if !value then 
							return true
						else
							return #payload.specSkills < 2
						end
					end

					specChecks[skillTbl.uniqueID] = specCheck

					local skillPnlH = 40

					local contentPnlH = 16

					for k, v in ipairs(contentPnl:GetChildren()) do
						local marginL, marginT, marginR, marginB = v:GetDockMargin()
						contentPnlH = contentPnlH + v:GetTall() + marginT + marginB
					end

					skillPnlH = skillPnlH + contentPnlH

					skillPnl:SetTall(skillPnlH)

					local skillVal = contentPnl:Add("ixLabel")
					skillVal:SetSize(contentPnlH, contentPnlH)
					skillVal:SetPos(ScrW() - self:GetNavbarSize() - skillVal:GetWide() - 30)
					skillVal:SetFont("prMenuButtonHugeFont")

					function skillPnl:SetupDisplayValue(addBoost)
						local boost = addBoost and 15 or 0 
						if skillTbl.boosts.smallBoost != nil then
							skillVal:SetText(ix.skills.CalculateBase(skillTbl.uniqueID, payload.attributes[string.lower(skillTbl.boosts.largeBoost)] or 5, payload.attributes[string.lower(skillTbl.boosts.smallBoost)] or 5) + boost)
						else
							skillVal:SetText(ix.skills.CalculateBase(skillTbl.uniqueID, payload.attributes[string.lower(skillTbl.boosts.largeBoost)] or 5) + boost)
						end
					end

					function specCheck:OnChanged(newValue)
						local specOffset = 0
						hasValue = table.HasValue(payload.specSkills, self.skill)
						if newValue then
							if !hasValue then
								table.insert(payload.specSkills, self.skill)
							end
							skillVal:SetTextColor(Color(231, 123, 56))
							specOffset = 15
						else
							if hasValue then
								table.RemoveByValue(payload.specSkills, self.skill)
							end
							skillVal:SetTextColor(color_white)
						end

						skillPnl:SetupDisplayValue(newValue)

						if 2 - #payload.specSkills == 1 then
							countLbl:SetText(2 - #payload.specSkills.." Skill Left")
						else
							countLbl:SetText(2 - #payload.specSkills.." Skills Left")
						end
					end	

					timer.Simple(0, function()
						specCheck:SetChecked(table.HasValue(payload.specSkills, skillTbl.uniqueID))
						skillPnl:SetupDisplayValue(specCheck:GetChecked())
					end)
					
				end

				-- we do this here because we want to make sure it repopulates every time it reopens
				subpanel.populated = false
			end
		},
		[4] = {
			name = "Traits",
			index = "traits",
			populate = function(subpanel)
				local panel = subpanel:Add("DPanel")
				panel:Dock(FILL)
				panel.Paint = function(panel, w, h)
					surface.SetDrawColor(44, 44, 44)
					surface.DrawRect(0, 0, w, h)	
				end

				panel:DockPadding(10, 0, 5, 0)

				local heading = panel:Add("DLabel")
				heading:Dock(TOP)
				heading:SetFont("ixCharNameFont")
				heading:SetText("Traits")
				heading:SizeToContents()
				heading:DockMargin(0, 0, 0, -22)

				local subtitle = panel:Add("DLabel")
				subtitle:Dock(TOP)
				subtitle:SetFont("prSubTitleFont")
				subtitle:SetText("Select up to two traits, perks that have both positive and negative effects.")
				subtitle:SizeToContents()
				subtitle:DockMargin(0, 0, 0, -7)

				local countLbl = panel:Add("DLabel")
				countLbl:Dock(TOP)
				countLbl:SetFont("prSubTitleFont")
				countLbl:SetText("2 Traits Left")
				countLbl:SizeToContents()

				local scrollPanel = panel:Add("DScrollPanel")
				scrollPanel:Dock(FILL)
				scrollPanel:DockMargin(0, 0, 0, 0)
				scrollPanel:GetCanvas():DockPadding(0, 10, 0, 10)

				local createButton = panel:Add("DButton")
				local subpanelW = ScrW() - self:GetNavbarSize()
				createButton:SetSize(self.charButton:GetSize())
				createButton.Paint = self.charButton.Paint
				createButton:SetFont(self.charButton:GetFont())
				createButton:SetPos(subpanelW - createButton:GetWide() - 5, ScrH() - createButton:GetTall() - 5)
				createButton:SetText("Create Character")

				createButton.DoClick = function()
					self:SendPayload()
				end
				

				local payload = self.payload

				for k, traitTbl in ipairs(ix.traits.list) do
					local traitPnl = panel:Add("Panel")
					traitPnl:Dock(TOP)
					traitPnl:DockMargin(0, 0, 0, 15)
					traitPnl.trait = k
				
					local headerPnl = traitPnl:Add("DPanel")
					headerPnl:Dock(TOP)
					headerPnl:SetTall(40)
					--headerPnl:SetBackgroundColor(Color(32, 32, 32, 100))
				
					local header = headerPnl:Add("ixLabel")
					header:Dock(FILL)
					header:SetText(traitTbl.name)
					header:SetFont("prMenuButtonFontSmall")
					header:SizeToContents()
					header:SetContentAlignment(5)	
				
					local contentPnl = traitPnl:Add("Panel")
					contentPnl:Dock(FILL)
					contentPnl:DockPadding(5, 8, 5, 8)
				
					contentPnl.Paint = function(panel, w,  h)
						surface.SetDrawColor(20, 20, 20)
						surface.DrawOutlinedRect(0, -1, w, h + 1)
					end
					
					local desc = contentPnl:Add("DLabel")
					desc:Dock(TOP)
					desc:SetWrap(true)
					desc:SetFont("prToolTipText")
					desc:SetText(traitTbl.description)
				
					local checkbox = contentPnl:Add("prCheckboxLabel")
					checkbox:Dock(TOP)
					checkbox:SetTall(30)
					checkbox:SetText("Specialize")
					checkbox:SetFont("prToolTipText")
				
					checkbox.trait = k
				
					function checkbox:CanChangeValue(value)
						if !value then 
							return true
						else
							return #payload.traits < 2
						end
					end
				
					local traitPnlH = 40
				
					local contentPnlH = 16
				
					for k, v in ipairs(contentPnl:GetChildren()) do
						local marginL, marginT, marginR, marginB = v:GetDockMargin()
						contentPnlH = contentPnlH + v:GetTall() + marginT + marginB
					end
				
					traitPnlH = traitPnlH + contentPnlH
				
					traitPnl:SetTall(traitPnlH)
				
					function checkbox:OnChanged(newValue)
						hasValue = table.HasValue(payload.traits, self.trait)
						if newValue then
							if !hasValue then
								table.insert(payload.traits, self.trait)
							end
						else
							if hasValue then
								table.RemoveByValue(payload.traits, self.trait)
							end
						end
				
						if 2 - #payload.traits == 1 then
							countLbl:SetText(2 - #payload.traits.." Trait Left")
						else
							countLbl:SetText(2 - #payload.traits.." Traits Left")
						end
					end	
				
					timer.Simple(0, function()
						checkbox:SetChecked(table.HasValue(payload.traits, k))
					end)
					
				end
				subpanel.populated = true
			end
		},

	}

	local whitelists = {}

	for _, v in SortedPairs(ix.faction.teams) do
		if (ix.faction.HasWhitelist(v.index)) then
			whitelists[#whitelists + 1] = v.index
		end
	end

	local hasWhitelists = #whitelists > 0

	if hasWhitelists then
		table.insert(subpanels, 1, {
			name = "Faction",
			index = "faction",
			populate = function(subpanel)	
				local panel = subpanel:Add("DPanel")
				panel:DockPadding(10, 0, 5, 5)
				panel:Dock(FILL)
				panel.Paint = function(panel, w, h)
					surface.SetDrawColor(44, 44, 44)
					surface.DrawRect(0, 0, w, h)
				end

				local header = panel:Add("DLabel")
				header:Dock(TOP)
				header:SetFont("ixCharNameFont")
				header:SetText("Choose a Faction")
				header:SizeToContents()

				local factions = ix.faction.list or {}
				if !ix.faction.list then
					self.FactionsNotLoaded = true
				else
					self:PopulateFactions()
				end

				self.facLayout = panel:Add("DGrid")
				self.facLayout:SetCols(2)
				self.facLayout:SetColWide(ScreenScale(150) + 8)

				

				self.facLayout:SetRowHeight(ScreenScale(35) + 8)
			end
		})
	end	

	for id, data in ipairs(subpanels) do
		if istable(data) then
			data.id = data.index

			local subpanel = self.displayWindow:Add("Panel")
			subpanel:Dock(FILL)
			subpanel.id = data.index
			subpanel.populated = false

			subpanel.PopulateFunc = data.populate

			-- This is the x position of the subpanels, used for animating. This is relative to each other in panels, and is not equivalent to real screen pixels.
			subpanel.yPos = table.Count(self.subpanels) + 1
			subpanel:Hide()

			self.subpanels[data.index] = subpanel
			subpanel.populated = false

			self:CreateButton(data)
		end
	end


	if hasWhitelists then
		self:SetActiveSubpanel("faction", false)
	else
		
		self:SetActiveSubpanel("appearance", false)
	end

end

function PANEL:ResetPayload()
	self.payload = {}
	self.payload.specSkills = {}
	self.payload.attributes = {
		strength = 5,
		agility = 5,
		intelligence = 5,
		constitution = 5
	}
	self.payload.skin = 0
	self.payload.traits = {}
	--self.payload.name = ""
	--self.payload.description = ""
end

function PANEL:SetActiveSubpanel(id, showAnimation)
	if showAnimation then
		if !self.subpanels[id].populated then 
			self.subpanels[id]:Clear()
			timer.Simple(0, function()
				self.subpanels[id].PopulateFunc(self.subpanels[id])
			end)
		elseif id == "appearance" and self.subpanels[id].faction != self.payload.faction.index then
			-- we don't want to reset the faction because that was already set before here.
			local faction = self.payload.faction
			self:ResetPayload()
			self.payload.faction = faction
			self.subpanels[id]:Clear()
			timer.Simple(0, function()
				self.subpanels[id].PopulateFunc(self.subpanels[id])
			end)
		end

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

			if IsValid(dummySubpanel.model) then
				dummySubpanel.model:SetLookAng(Angle(0, 180, 0))
			end

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

function PANEL:PopulateFactions()
	local factions = ix.util.AlphabetizeByMember(ix.faction.teams, "name")
	local numFactions = #factions
	local facTiles = {}
	for i = 1, numFactions - numFactions%2 do
		local tile = self:Add("DButton")
		tile:SetSize(self.facLayout:GetColWide() - 8, self.facLayout:GetRowHeight() - 8)
		tile.faction = factions[i]
		tile:SetPos(4, 4)
		tile:SetContentAlignment(5)
		
		tile:SetText(factions[i].name)
		tile:SetFont("prMenuButtonFontThick")
		--tile:SetImage(factions[i].bgImage or nil)
		/*

		local text = tile:Add("ixLabel")
		text:SetFont("prMenuButtonFontThick")
		text:Dock(FILL)
		text:SetContentAlignment(2)
		text:SetText(factions[i].name)
		*/
		self.facLayout:AddItem(tile)

		
		
		tile.DoClick = function(panel)
			if !ix.faction.HasWhitelist(factions[i].index) then
				self:ShowNotice(3, "You are not whitelisted for that faction!")
				return
			end
			self.payload.faction = panel.faction
			self:SetActiveSubpanel("appearance", true)
		end

		--tile:MoveToFront()
	end

	local canvasW = self:GetWide() - self:GetNavbarSize()

	self.facLayout:SetSize(2*self.facLayout:GetColWide(), math.floor(#factions/2)*self.facLayout:GetRowHeight())
	self.facLayout:SetPos(canvasW/2 - self.facLayout:GetWide()/2, self:GetTall()/2 - self.facLayout:GetTall()/2)

	if numFactions%2 != 0 then
		self.facLayout:SetY(self.facLayout:GetY() - self.facLayout:GetRowHeight()/2 - 8)
		local tile = self.facLayout:GetParent():Add("DButton")
		tile:SetText(factions[numFactions].name)
		tile:SetSize(self.facLayout:GetColWide() - 8, self.facLayout:GetRowHeight() - 8)
		tile:SetContentAlignment(5)
		tile:SetFont("prMenuButtonFontThick")
		

		tile:SetPos(self.facLayout:GetX() + self.facLayout:GetColWide()/2, self.facLayout:GetY() + self.facLayout:GetRowHeight()*math.floor(numFactions/2))
	end
end

function PANEL:Think()
	if self.FactionsNotLoaded then
		if ix.faction.teams != nil then
			self.FactionsNotLoaded = false
			self:PopulateFactions()
		end
	end
end

function PANEL:SendPayload()
	self.awaitingResponse = true



	timer.Create("ixCharacterCreateTimeout", 10, 1, function()
		if (IsValid(self) and self.awaitingResponse) then

			self.awaitingResponse = false

			--parent.mainPanel:Undim()
			self:ShowNotice(3, L("unknownError"))
		end
	end)

	net.Start("ixCharacterCreate")
	

	local friendlyPayload = table.Copy(self.payload)
	friendlyPayload.faction = self.payload.faction.index

	friendlyPayload.model = table.KeyFromValue(self.payload.faction.models, self.payload.model)

	net.WriteUInt(table.Count(friendlyPayload), 32)

	for k, v in pairs(friendlyPayload) do
		local dataType = TypeID(v)
		local compressedKey = util.Compress(k)

		net.WriteInt(dataType, 8)
		net.WriteInt(#compressedKey, 32)
		net.WriteData(compressedKey)

		if dataType == TYPE_NUMBER then
			net.WriteInt(v, 32)
		else
			local compressed

			if dataType == TYPE_TABLE then
				local stringTbl = util.TableToJSON(v)
				compressed = util.Compress(stringTbl)
			else
				compressed = util.Compress(v)
			end

			net.WriteInt(#compressed, 32)
			net.WriteData(compressed)
		end
	end

	net.SendToServer()
end

function PANEL:OnSlideUp()
	self:ResetPayload()
	self:Populate()
	self.progress:SetProgress(1)

	-- the faction subpanel will skip to next subpanel if there is only one faction to choose from,
	-- so we don't have to worry about it here
	self:SetActiveSubpanel("faction", 0)
end

function PANEL:ShowNotice(type, text)
	self.notice:SetType(type)
	self.notice:SetText(text)
	self.notice:Show()
end

function PANEL:Dim(length, callback)
	length = length or animationTime
	self.currentDimAmount = 0

	self:CreateAnimation(length, {
		target = {
			currentDimAmount = self.targetDimAmount,
		},
		easing = "outCubic",
		OnComplete = callback
	})
end

function PANEL:Undim(length, callback)
	length = length or animationTime
	self.currentDimAmount = self.targetDimAmount

	self:CreateAnimation(length, {
		target = {
			currentDimAmount = 0,
		},
		easing = "outCubic",
		OnComplete = callback
	})
end

function PANEL:OnSlideDown()
end

function PANEL:SetPayload(key, value)
	self.payload[key] = value
	self:RunPayloadHook(key, value)
end

function PANEL:AddPayloadHook(key, callback)
	if (!self.hooks[key]) then
		self.hooks[key] = {}
	end

	self.hooks[key][#self.hooks[key] + 1] = callback
end

function PANEL:RunPayloadHook(key, value)
	local hooks = self.hooks[key] or {}

	for _, v in ipairs(hooks) do
		v(value)
	end
end

function PANEL:GetContainerPanel(name)
	-- TODO: yuck
	if (name == "description") then
		return self.descriptionPanel
	elseif (name == "attributes") then
		return self.attributesPanel
	elseif (name == "skills") then
		return self.skillsPanel
	end

	return self.descriptionPanel
end

function PANEL:AttachCleanup(panel)
	self.repopulatePanels[#self.repopulatePanels + 1] = panel
end

function PANEL:Populate()

end

function PANEL:VerifyProgression(name)
	for k, v in SortedPairsByMemberValue(ix.char.vars, "index") do
		if (name ~= nil and (v.category or "description") != name) then
			continue
		end

		local value = self.payload[k]

		if (!v.bNoDisplay or v.OnValidate) then
			if (v.OnValidate) then
				local result = {v:OnValidate(value, self.payload, LocalPlayer())}

				if (result[1] == false) then
					self:ShowNotice(3, L(unpack(result, 2)))
					return false
				end
			end

			self.payload[k] = value
		end
	end

	return true
end

vgui.Register("ixCharMenuNew", PANEL, "prMenu")

PANEL = {}

AccessorFunc(PANEL, "value", "Value", FORCE_NUMBER)
AccessorFunc(PANEL, "text", "Text", FORCE_STRING)
AccessorFunc(PANEL, "desc", "Description", FORCE_STRING)

function PANEL:Init()
	
	self.value = 5


	self.leftBody = self:Add("Panel")
	self.leftBody:Dock(FILL)
	self.leftBody:DockPadding(5, -7, 0, 0)

	self.rightBody = self:Add("Panel")
	self.rightBody:Dock(RIGHT)
	self.rightBody:SetWide(150)

	self.topRow = self.leftBody:Add("Panel")
	self.topRow:Dock(TOP)
	self.topRow:SetTall(50)

	self.label = self.topRow:Add("DLabel")
	self.label:Dock(LEFT)
	self.label:SetFont("prMenuButtonFontThick")

	self.adjuster = self.rightBody:Add("Panel")
	self.adjuster:Dock(FILL)

	self.downBtn = self.adjuster:Add("DButton")
	self.downBtn:Dock(LEFT)
	self.downBtn:SetSize(50, 50)
	self.downBtn:SetText("")
	function self.downBtn:DoClick()
		local parent = self:GetParent():GetParent():GetParent()
		local value = parent:GetValue()

		if value > 1 then
			parent:SetValue(value - 1)
		else
			return
		end

		parent:PostClick(-1)
	end

	local arrowInset = 14

	function self.downBtn:Paint(w, h)
		if self:IsDown() then
			surface.SetDrawColor(134, 134, 134)
		elseif self:IsHovered() then
			surface.SetDrawColor(173, 173, 173)
		else
			surface.SetDrawColor(255, 255, 255)
		end
		
		draw.NoTexture()

		surface.DrawPoly({
			{x = 0 + arrowInset, y = h/2},
			{x = w - arrowInset, y = 0 + arrowInset},
			{x = w - arrowInset , y = h - arrowInset}
		})
	end

	self.valueDisplay = self.adjuster:Add("ixLabel")
	self.valueDisplay:Dock(FILL)
	self.valueDisplay:SetText(5)
	self.valueDisplay:SetFont("prMenuButtonFont")

	self.upBtn = self.adjuster:Add("DButton")
	self.upBtn:Dock(RIGHT)
	self.upBtn:SetSize(50, 50)
	self.upBtn:SetText("")

	function self.upBtn:Paint(w, h)
		if self:IsDown() then
			surface.SetDrawColor(134, 134, 134)
		elseif self:IsHovered() then
			surface.SetDrawColor(173, 173, 173)
		else
			surface.SetDrawColor(255, 255, 255)
		end

		draw.NoTexture()

		surface.DrawPoly({
			{x = 0 + arrowInset, y = 0 + arrowInset},
			{x = w - arrowInset, y = h/2},
			{x = 0 + arrowInset, y = h - arrowInset}
		})
	end

	function self.upBtn:DoClick()	
		local parent = self:GetParent():GetParent():GetParent()
		local value = parent:GetValue()

		if !parent:CanIncrease() then return end

		if value < 10 then
			parent:SetValue(value + 1)
		else
			return
		end

		parent:PostClick(1)
	end

	self.descPnl = self.leftBody:Add("Panel")
	self.descPnl:Dock(TOP)
	self.descPnl:SetTall(50)
	self.descPnl:DockMargin(0, 0, 0, 0)

	self.descLbl = self.descPnl:Add("DLabel")
	self.descLbl:Dock(FILL)
	self.descLbl:SetWrap(true)
	self.descLbl:SetFont("prToolTipText")
	self.descLbl:DockMargin(0, 0, 0, 0)

	--self.descPnl:MoveToBack()
	
end

function PANEL:SetText(text)
	self.text = text
	self.label:SetText(text)
	self.label:SizeToContentsX()
end

function PANEL:SetValue(value)
	self.value = value
	self.valueDisplay:SetText(value)
end

function PANEL:SetDescription(desc)
	self.desc = desc
	self.descLbl:SetText(desc)
	self.descPnl:SetTall(self.descLbl:GetTall())

	local totalH = self.topRow:GetTall() + self.descPnl:GetTall()

	self:SetTall(totalH)
	local adjusterMargin = (totalH - 50)/2
	

	self.adjuster:DockMargin(0, adjusterMargin, 0, adjusterMargin)
end

function PANEL:PostClick()
end

function PANEL:CanIncrease()
	return true
end

vgui.Register("prAttributeAdjust", PANEL, "DPanel")