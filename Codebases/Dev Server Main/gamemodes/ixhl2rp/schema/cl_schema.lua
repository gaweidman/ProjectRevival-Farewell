function Schema:AddCombineDisplayMessage(text, color, ...)
	if (LocalPlayer():HasBiosignal() and IsValid(ix.gui.combine)) then
		ix.gui.combine:AddLine(text, color, nil, ...)
	end
end

cmbLogoColor = Color(176, 124, 32)

-- Terminal Stuff
surface.CreateFont("VCR", {
	font = "RuneScape UF",  
	size = ScrW()*0.02, 
	weight = 10, 
	blursize = 0, 
	scanlines = 2.5, 
	antialias = false
})

surface.CreateFont("VCREntity", {
	font = "RuneScape UF",  
	size = ScrW()*0.02, 
	weight = 10, 
	blursize = 0, 
	antialias = false
})

surface.CreateFont("VCRBig", {
	font = "RuneScape UF",  
	size = ScrW()*0.1, 
	weight = 9000, 
	blursize = 0,
	scanlines = 2.5, 
	antialias = false
})

VORTIGAUNT_BLUE_FADE_TIME = 2.25

matproxy.Add({
    name = "VortEmissive", 
    init = function( self, mat, values )

        local bFound;
        self.matEmissiveStrength = mat:GetFloat("$emissiveblendstrength")

        if ( self.matEmissiveStrength != nil ) then
            self.matDetailBlendStrength = mat:GetFloat("$detailblendfactor")
        end

        return bFound;
    end,
    bind = function( self, mat, ent )
        local flBlendValue;
        local isBlue = ent:GetNetVar("IsBlue", false)

        if (mat:GetName() == "models/vortigaunt/vortigaunt_blue") then
            local fadeBlueEndTime = ent:GetNetVar("fadeBlueEndTime", -1)    

            -- Do we need to crossfade?
            if (CurTime() < fadeBlueEndTime and fadeBlueEndTime != -1) then
                local fadeRatio = (fadeBlueEndTime - CurTime()) / VORTIGAUNT_BLUE_FADE_TIME;
                if (isBlue) then
                    fadeRatio = 1 - fadeRatio;
                end
                flBlendValue = math.Clamp( fadeRatio, 0, 1 )

            -- No, we do not.
            else 
                if isBlue then flBlendValue = 1 else flBlendValue = 0 end
            end
        else
            flBlendValue = 0;
        end

        if ( self.matEmissiveStrength != nil ) then
            mat:SetFloat("$emissiveblendstrength", flBlendValue)
        end

        if( self.matDetailBlendStrength != nil ) then
            mat:SetFloat("$detailblendfactor", flBlendValue)
        end
    end 
})

local W, H = ScrW(), ScrH()
NTime, NFan, NDisk = CurTime(), CurTime(), CurTime() 	

local SKIN = derma.GetNamedSkin("helix")

function SKIN:PaintFrame(panel)
	if (!panel.bNoBackgroundBlur) then
		ix.util.DrawBlur(panel, 10)
	end

	surface.SetDrawColor(30, 30, 30, 150)
	surface.DrawRect(0, 0, panel:GetWide(), panel:GetTall())

	if (panel:GetTitle() != "" or panel.btnClose:IsVisible()) then
		surface.SetDrawColor(ix.config.Get("color"))
		surface.DrawRect(0, 0, panel:GetWide(), 24)

		if (panel.bHighlighted) then
			self:DrawImportantBackground(0, 0, panel:GetWide(), 24, ColorAlpha(color_white, 22))
		end
	end

	surface.SetDrawColor(Color(0, 0, 0))
	surface.DrawOutlinedRect(0, 0, panel:GetWide(), panel:GetTall())
end

function SKIN:DrawImportantBackground(x, y, width, height, color)
	color = color or defaultBackgroundColor

	draw.NoTexture()

	surface.SetDrawColor(color)
	surface.DrawTexturedRect(x, y, width, height)
end

function SKIN:PaintHelixSlider(panel, w, h)
	local visualFraction = panel:GetVisualFraction()
	if panel.segmented then
		local numSegments = panel:GetMax() - panel:GetMin()
		local segmentW = w/numSegments
		local value = panel:GetValue()
		local visualFraction = panel:GetVisualFraction()
		local fraction = panel:GetFraction()

		
		for i = 0, numSegments - 1 do
			surface.SetDrawColor(self.Colours.DarkerBackground)
			surface.DrawRect(segmentW*i, 0, segmentW - ((i < numSegments - 1) and 3 or 0), h)
		end

		for i = 0, value do
			local margin = (i < numSegments) and 3 or 0
			surface.SetDrawColor(self.Colours.Success)
			if visualFraction < fraction then
				if i < fraction*numSegments - 1 then
					surface.DrawRect(segmentW*(i), 0, segmentW - margin, h)
				else
					surface.DrawRect(segmentW*i, 0, (segmentW - margin)*(visualFraction*numSegments - i), h)
				end
			elseif visualFraction > fraction then
				if i < fraction*numSegments then
					surface.DrawRect(segmentW*(i), 0, segmentW - margin, h)
				else
					surface.DrawRect(segmentW*(i), 0, (segmentW - margin)*(visualFraction*numSegments - i), h)
				end
			else
				surface.DrawRect(segmentW*(i - 1), 0, segmentW - margin, h)
			end
		end
	else
		surface.SetDrawColor(self.Colours.DarkerBackground)
		surface.DrawRect(0, 0, w, h)
		
		surface.SetDrawColor(self.Colours.Success)
		surface.DrawRect(0, 0, visualFraction * w, h)
	end

	
end 

SKIN = derma.GetNamedSkin("icterminal")

if SKIN == nil then SKIN = {} end

SKIN.text_normal = Color(0, 0, 0)
SKIN.Colours = {}
SKIN.Colours.Window = {}

SKIN.Colours.Window.TitleActive = Color(255, 255, 255)
SKIN.Colours.Label = {}
SKIN.Colours.Label.Default = Color(0, 0, 0)

SKIN.Colours.Button = {}
SKIN.Colours.Button.Normal			= Color(255, 255, 255)
SKIN.Colours.Button.Hover			= Color(0, 0, 0, 50)
SKIN.Colours.Button.Down			= Color(0, 0, 0, 50)
SKIN.Colours.Button.Disabled		= GWEN.TextureColor( 4 + 8 * 3, 500 )

SKIN.colTextEntryTextHighlight	= Color( 20, 200, 250, 255 )

function SKIN:PaintFrame(panel, w, h)
	surface.SetDrawColor(209, 209, 209)
	surface.DrawRect(0, 0, w, h)

	surface.SetDrawColor(68, 87, 68)
	surface.DrawRect(0, 0, w, 23)

	surface.SetDrawColor(0, 0, 0)
	surface.DrawOutlinedRect(0, 0, w, h, 2)

	surface.DrawLine(0, 23, w, 23)
end

function SKIN:PaintButton(panel, w, h)
	surface.SetDrawColor(color_white)
	surface.DrawRect(0, 0, w, h)

	surface.SetDrawColor(color_black)
	surface.DrawOutlinedRect(0, 0, w, h, 1)

	surface.SetDrawColor(0, 0, 0, 50)
	if panel:IsHovered() then
		surface.DrawRect(0, 0, w, h)
	end

	if panel:IsDown() then
		surface.DrawRect(0, 0, w, h)
	end
end

function SKIN:PaintTextEntry(panel, w, h)
	surface.SetDrawColor(255, 255, 255)
	surface.DrawRect(0, 0, w, h)
	
	surface.SetDrawColor(0, 0, 0)
	surface.DrawOutlinedRect(0, 0, w, h, 1)
	panel:DrawTextEntryText(color_black, self.colTextEntryTextHighlight, color_black)
end

if derma.GetNamedSkin("icterminal") == nil or table.Count(derma.GetNamedSkin("icterminal")) == 0 then
	derma.DefineSkin("icterminal", "A skin for IC terminals.", SKIN)
end


derma.RefreshSkins() 	

function Schema:AddCombineDisplayMessage(text, color, ...)
	if (LocalPlayer():IsCombine() and IsValid(ix.gui.combine)) then
		ix.gui.combine:AddLine(text, color, nil, ...)
	end
end

local function ScreenScaleW(num)
	return num*(ScrW()/640)
end



function ix.util.DrawRoundedBox(r, x, y, w, h, color)
	return draw.RoundedBox(r, ScreenScaleH(x), ScreenScaleH(y), ScreenScaleH(w), ScreenScaleH(h), color)
end

function ix.util.DrawRect(x, y, w, h)
	return surface.DrawRect(ScreenScaleH(x), ScreenScaleH(y), ScreenScaleH(w), ScreenScaleH(h))
end

function ix.util.SimpleText(text, font, x, y, color, xAlign, yAlign)
	return draw.SimpleText(text, font, ScreenScaleH(x), ScreenScaleH(y), color, xAlign, yAlign)
end

local PANEL = {}

AccessorFunc(PANEL, "baseW", "BaseWidth")
AccessorFunc(PANEL, "baseH", "BaseHeight")

function PANEL:Init()
	self:SetSize(1800, 950)
	self:SetPos(0, 0)

	self.baseW = 700
	self.baseH = 500
	
	self.loading = true
	self.paintRotation = true
	self.curAngle = 0

	self.guard = self:Add("Panel")
	self.guard:SetSize(ScrW(), ScrH())
	self.guard:SetPos(0, 0)

	self.display = self:Add("Panel")
	self.display:SetSize(700, 500)
	self.display:Center()

	print(self.display)

	self.curWindow = self:Add("EditablePanel")
	self.curWindow.baseW = 700
	self.curWindow.baseH = 500

	self.curW = 700
	self.curH = 500

	self:ShowMainMenu()
end

function PANEL:SetBaseSize(w, h)
	self.baseW = w
	self.baseH = h
	self.curWindow:SetSize(w, h)
	self.curWindow:Center()
end

function PANEL:ShowWindow(class)
	self:Clear()
	if self.curWindow then self.curWindow:Remove() end
	self.curWindow = self:Add(class)
	self.curWindow:Center()
	print("pos", self.curWindow:GetPos())

	self.loading = true

	if self.curWindow.baseW != self.baseW or self.curWindow.baseH != self.baseH then
		-- if one is landscape and the other is portrait
		if self.curWindow.baseW > self.curWindow.baseH != self.baseW > self.baseH then
			self.paintRotation = true
			panel.curW = self.baseW
			panel.curH = self.baseH

			self:CreateAnimation(0.75, {
				index = 2,
				target = {curAngle = 90},
				easing = "outCubic",

				OnComplete = function(animation, panel)
					if self.curWindow.baseW != self.baseH or self.curWindow.baseH != self.baseW then
						panel.curW = 700
						panel.curH = 500

						panel:CreateAnimation(0.75, {
							index = 2,
							target = {curW = self.curWindow.baseH, curH = self.curWindow.baseW}, -- this is inverted because the draws are done at a 90 degree angle.
							easing = "outCubic",

							OnComplete = function(animation, panel)
								panel.display:SetSize(self.curWindow.baseW, self.curWindow.baseH)
								panel.display:Center()
								panel.button:Center()	
							end
						})
					else
						panel.display:SetSize(self.curWindow.baseW, self.curWindow.baseH)
						panel.display:Center()
					end
				end
			})
		else
			self:CreateAnimation(0.75, {
				index = 1,
				target = {curAngle = 90},
				easing = "outQuad",

				OnComplete = function(animation, panel)
					panel.curW = self.baseW
					panel.curH = self.baseH

					panel:CreateAnimation(0.75, {
						index = 2,
						target = {curW = self.curWindow.baseW, curH = self.curWindow.baseH},
						easing = "outCubic",

						OnComplete = function(animation, panel)
							panel.display:SetSize(self.curWindow.baseW, self.curWindow.baseH)
							panel.display:Center()
							panel.button:Center()	
						end
					})
				end
			})
		end
	end
end

function PANEL:ShowMainMenu()
	local curW, curH = self:GetSize()
	if curW != self.baseW or curH != self.baseH then
		if self.curWindow.baseW != self.baseW or self.curWindow.baseH != self.baseH then
			-- if one is landscape and the other is portrait
			print(self.curWindow.baseW, self.curWindow.baseH, self.baseW, self.baseH)
			if self.curWindow.baseW > self.curWindow.baseH != self.baseW > self.baseH then
				self.paintRotation = true
				panel.curW = self.baseW
				panel.curH = self.baseH
	
				self:CreateAnimation(0.75, {
					index = 2,
					target = {curAngle = 90},
					easing = "outCubic",
	
					OnComplete = function(animation, panel)
						if self.curWindow.baseW != self.baseH or self.curWindow.baseH != self.baseW then
							panel.curW = 700
							panel.curH = 500
	
							panel:CreateAnimation(0.75, {
								index = 2,
								target = {curW = self.curWindow.baseH, curH = self.curWindow.baseW}, -- this is inverted because the draws are done at a 90 degree angle.
								easing = "outCubic",
	
								OnComplete = function(animation, panel)
									panel.display:SetSize(self.curWindow.baseW, self.curWindow.baseH)
									panel.display:Center()
									panel.button:Center()	
								end
							})
						else
							panel.display:SetSize(self.curWindow.baseW, self.curWindow.baseH)
							panel.display:Center()
						end
					end
				})
			else
				self:CreateAnimation(0.75, {
					index = 1,
					target = {curAngle = 90},
					easing = "outQuad",
	
					OnComplete = function(animation, panel)
						panel.curW = self.baseW
						panel.curH = self.baseH
	
						panel:CreateAnimation(0.75, {
							index = 2,
							target = {curW = self.curWindow.baseW, curH = self.curWindow.baseH},
							easing = "outCubic",
	
							OnComplete = function(animation, panel)
								panel.display:SetSize(self.curWindow.baseW, self.curWindow.baseH)
								panel.display:Center()
								panel.button:Center()	
							end
						})
					end
				})
			end
		end
	end
end

function PANEL:Paint(w, h)
	if self.loading then
		if self.paintRotation then
			local dispX, dispY = self.curWindow:GetPos()
			local dispW, dispH = self.curWindow:GetSize()
			draw.NoTexture()
			surface.SetDrawColor(187, 187, 187)
			surface.DrawTexturedRectRotated(w/2, h/2, self.curW + 8, self.curH + 8, self.curAngle)
			surface.SetDrawColor(color_black)
			surface.DrawTexturedRectRotated(w/2, h/2, self.curW, self.curH, self.curAngle)

			--draw.SimpleText("Loading...", "DermaLarge", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			local dispX, dispY = self.curWindow:GetPos()
			local dispW, dispH = self.curWindow:GetSize()
			surface.SetDrawColor(187, 187, 187)
			surface.DrawRect(dispX, dispY, dispX, dispY)
			surface.SetDrawColor(color_black)
			surface.DrawRect(dispX, dispY, dispW - 8, dispH - 8)
		end
	end
end

vgui.Register("DisplayPanel", PANEL, "EditablePanel")

PANEL = {}

function PANEL:Init()
	self.baseW = 400
	self.baseH = 600
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(255, 255, 0)
	surface.DrawRect(0, 0, w, h)
end

PANEL = {}

vgui.Register("DisplayPanelBase", PANEL, "EditablePanel")

function PANEL:Init()
	self:SetSize(700, 500)
	self:Center()

	LocalPlayer():EmitSound("npc/scanner/combat_scan2.wav")

	if self:GetParent() == nil then
		self:SetPos(ScrW()/2 - 700/2, ScrH())
		self.yPos = ScrH()
		self:CreateAnimation(0.85, {
			index = 1,
			target = {yPos = ScrH()/2 - 500/2},
			easing = "outQuint",

			Think = function(animation, panel)
				panel:SetY(panel.yPos)
			end,

			OnComplete = function(animation, panel)
				panel:Center()
			end
		})
	end
	
	--self:ShowCloseButton(true)
	self.Paint = function(pan, w, h)

	end

	net.Receive("prTimeclock", function(len)
		if net.ReadBool() then
			if self.timeTable then
				self:SetupTimeHistory()
			end
		else

		end
	end)
	
	self.silentCooldown = -1

	self.screenSetups = {
		["loading"] = {
			populate = function(container) end,
			paint = function(container, w, h)
				surface.SetDrawColor(65, 65, 65)
				surface.DrawRect(0, 0, w, h)
		
					local radius = 24
		
					local textW, textH = draw.SimpleText("LOADING...", "ixBigFont", w/2 - radius, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
					surface.SetMaterial(overlayMat)
					--surface.DrawTexturedRect(0, 0, w, h)
					
		
					local circleX, circleY = w/2 + radius + textW/2, h*0.5
		
				
					local numDots = 8
		
					surface.SetMaterial(dot)
					for i=1, numDots do
						if i == 1 then
							surface.SetDrawColor(255, 0, 255)
						else
							surface.SetDrawColor(255, 255, 255)
						end
						local theta = (CurTime()*2) + (i*math.pi*2)/numDots
						surface.DrawTexturedRect(circleX + radius*math.cos(theta), circleY + radius*math.sin(theta), 4, 4)
					end
			end
		},
		["mainscreen"] = {
			populate = function(container, w, h)
				local leftPanel = container:Add("Panel")
				local rightPanel = container:Add("Panel")

				leftPanel:Dock(LEFT)
				rightPanel:Dock(FILL)

				leftPanel:SetWide(w*0.6)

				leftPanel.Paint = function(panel, w, h)
					surface.SetDrawColor(56, 65, 55)
					surface.DrawRect(0, 0, w, h)
				end

				rightPanel.Paint = function(panel, w, h)
					surface.SetDrawColor(color_white)
					surface.DrawRect(0, 0, w, h)
				end

				local lTopBar = leftPanel:Add("Panel")
				lTopBar:Dock(TOP)
				lTopBar:SetTall(h*0.25)

				local lBottomBar = leftPanel:Add("Panel")
				lBottomBar:Dock(BOTTOM)
				lBottomBar:SetTall(h*0.25)

				
				local lCenterBar = leftPanel:Add("Panel")
				lCenterBar:Dock(FILL)
				lCenterBar:SetTall(h*0.5)
				lCenterBar:DockPadding(5, 5, 5, 5)

				local nameRow = lCenterBar:Add("Panel")
				nameRow:DockMargin(35, 0, 35, 0)
				nameRow:Dock(TOP)
				nameRow:SetTall(40)
				nameRow.Paint = function(pan, w, h)
					surface.SetDrawColor(255, 255, 255)
					surface.DrawRect(0, 0, w, h)
				end

				local nameLabel = nameRow:Add("ixLabel")
				nameLabel:Dock(FILL)
				nameLabel:SetText(LocalPlayer():GetCharacter():GetName())
				nameLabel:SetFont("DermaLarge")
				nameLabel:SetTextColor(color_black)
				nameLabel:SetContentAlignment(5)

				local businessRow = lCenterBar:Add("Panel")
				businessRow:Dock(FILL)
				businessRow:DockMargin(10, 0, 10, 0)
				businessRow.Paint = function(panel, w, h)
					surface.SetDrawColor(105, 117, 105)
					surface.DrawRect(0, 0, w, h)
				end

				local busiNameRow = businessRow:Add("ixLabel")
				busiNameRow:Dock(TOP)
				busiNameRow:SetTall(70)
				busiNameRow:SetFont("DermaLarge")
				busiNameRow:SetText("Grizzly Grotto")
				busiNameRow:SetContentAlignment(5)

				local busiJob = businessRow:Add("Panel")
				busiJob:Dock(FILL)
				busiJob:DockMargin(10, 0, 10, 25)
				
				local gradient_d = Material("vgui/gradient-d")
				local gradient_u = Material("vgui/gradient-u")
				busiJob.Paint = function(pan, w, h)
					surface.SetDrawColor(color_white)
					surface.DrawRect(0, 0, w, h)

					surface.SetDrawColor(124, 124, 124, 196)
					surface.DrawRect(0, 0, 3, h)
					surface.DrawRect(w-3, 0, 3, h)

					surface.SetDrawColor(56, 56, 56)
					surface.SetMaterial(gradient_u)
					
					surface.DrawTexturedRect(0, 0, w, 15)

					surface.DrawTexturedRect(0, 0, 3, h/2)
					surface.DrawTexturedRect(w-3, 0, 3, h/2)

					surface.SetMaterial(gradient_d)
					surface.DrawTexturedRect(0, h-15, w, 15)

					surface.DrawTexturedRect(0, h/2, 3, h/2)
					surface.DrawTexturedRect(w-3, h/2, 3, h/2)

					surface.SetDrawColor(90, 90, 90)
					surface.DrawOutlinedRect(0, h/2-15, w, 30, 1)

					surface.SetDrawColor(145, 145, 145, 121)
					surface.DrawRect(0, h/2, w, 15)
					
					surface.DrawTexturedRect(0, h/2 - 15, w, 15)

					draw.SimpleText("Sales Associate", "DermaDefaultBold", w/2, h/2, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

				end

				lTopBar.Paint = function(panel, w, h)
					local timeStr = os.date("%I:%M %p", system.SteamTime())
					draw.SimpleText(timeStr, "DermaLarge", w/2, h - 5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
				end

				local rBtmBar = rightPanel:Add("Panel")
				rBtmBar:SetTall(30)
				rBtmBar:Dock(BOTTOM)
				
				self.hoursLabel = rBtmBar:Add("DLabel")
				self.hoursLabel:Dock(RIGHT)
				self.hoursLabel:SetFont("DermaDefault")
				self.hoursLabel:SetText("Total Hours Worked: 0.0")
				self.hoursLabel:DockMargin(0, 0, 5, 0)
				self.hoursLabel:SizeToContents()
				self.hoursLabel:SetTextColor(color_black)

				local rBtnBar = rightPanel:Add("Panel")
				rBtnBar:SetTall(50)
				rBtnBar:Dock(BOTTOM)

				local btnSkin = function(pan, w, h)
					surface.SetDrawColor(160, 175, 165)
					surface.DrawRect(0, 0, w, h)

					surface.SetDrawColor(0, 0, 0, 50)					
					if pan:IsHovered() then
						surface.DrawRect(0, 0, w, h)
					end

					if pan:IsDown() then
						surface.DrawRect(0, 0, w, h)
					end
				end
				
				rBtnBar:DockPadding(5, 5, 5, 0)
				local logoutBtn = rBtnBar:Add("DButton")
				logoutBtn:Dock(RIGHT)
				logoutBtn:SetWide(100)
				logoutBtn:SetText("Log Out")
				logoutBtn:DockMargin(6, 0, 0, 0)
				logoutBtn:SetTextColor(color_black)
				logoutBtn:SetFont("DermaDefaultBold")
				logoutBtn.DoClick = function(pan)
					self:Logout()
				end
				logoutBtn.Paint = btnSkin

				local clockInOutBtn = rBtnBar:Add("DButton")
				clockInOutBtn:Dock(FILL)
				clockInOutBtn:SetText("Clock In")
				clockInOutBtn:SetFont("DermaDefaultBold")
				clockInOutBtn:SetTextColor(color_black)
				local char = LocalPlayer():GetCharacter()
				local timeClocks = char:GetData("TimeClocks", {})
					
				local clockTime = timeClocks[self.businessName or "BUSINESS15"]
				if !clockTime then
					clockInOutBtn:SetText("Clock In")
				else
					clockInOutBtn:SetText("Clock Out")
				end

				clockInOutBtn.DoClick = function(pan)
					if CurTime() < self.silentCooldown then return end

					local char = LocalPlayer():GetCharacter()
					local timeClocks = char:GetData("TimeClocks", {})
					
					local clockTime = timeClocks[self.businessName or "BUSINESS15"]
					if clockTime then
						pan:SetText("Clock In")
					else
						pan:SetText("Clock Out")
					end

					net.Start("prTimeclock")
						net.WriteString(self.businessName or "BUSINESS15")
					net.SendToServer()

					self.silentCooldown = CurTime() + 0.1
				end
				clockInOutBtn.Paint = btnSkin

				self.timeTable = rightPanel:Add("DListView")
				self.timeTable:Dock(FILL)
				self.timeTable:DockMargin(10, 10, 10, 10)
				self.timeTable:SetHeaderHeight(24)
				
			
				local cols = {
					["date"] = self.timeTable:AddColumn("Date", 1),
					["in"] =self.timeTable:AddColumn("In", 2),
					["out"] =self.timeTable:AddColumn("Out", 3),
					["hours"] = self.timeTable:AddColumn("Hours", 4)
				}

				cols["date"]:SetFixedWidth(56)
				cols["in"]:SetFixedWidth(67)
				cols["out"]:SetFixedWidth(67)
				cols["hours"]:SetFixedWidth(70)


				for k, v in pairs(cols) do
					v.Header:SetTextColor(Color(0, 0, 0))
					v.Header:SetFont("DermaDefaultBold")
					v.Header.Paint = function(pan, w, h)
						surface.SetDrawColor(color_black)
						surface.DrawOutlinedRect(0, 0, w, h, 1)
					end
					v.Header:SetCursor("arrow")

					v:SetTextAlign(5)
				end

				self:SetupTimeHistory()

				self.timeTable.Paint = function(pan, w, h)
					surface.SetDrawColor(231, 231, 231)
					surface.DrawRect(0, 0, w, h)

					surface.SetDrawColor(color_black)
					surface.DrawOutlinedRect(0, 0, w, h, 1)

					for k, v in ipairs(pan:GetChildren()) do
						v:PaintManual()
					end
				end

				self.timeTable.PaintOver = function(pan, w, h)
					surface.SetDrawColor(1, 36, 1)
					local headerHeight = pan:GetHeaderHeight()
					--surface.DrawLine(5, headerHeight, w-5, headerHeight)
				end
			end
		}
	}

	self.screens = {}
	for k, v in pairs(self.screenSetups) do
		local newPanel = self:Add("Panel")
		newPanel:Dock(FILL)
		newPanel:Hide()

		v.populate(newPanel, self:GetWide(), self:GetTall())
		if v.paint then newPanel.Paint = v.paint end
		self.screens[k] = newPanel
	end

	self.screens["mainscreen"]:Show()
end

-- this should be overridden when being displayed inside of another derma element
function PANEL:Logout()
	self:CreateAnimation(0.85, {
		index = 1,
		target = {yPos = ScrH()},
		easing = "outQuint",

		Think = function(animation, panel)
			panel:SetY(panel.yPos)
		end,

		OnComplete = function(animation, panel)
			panel:Remove()
		end
	})
end

function PANEL:SetupTimeHistory()
	self.timeTable:Clear()
	local timeHistory = LocalPlayer():GetCharacter():GetData("TimeClockHistory", {})
	local businessHistory = timeHistory[self.businessName or "BUSINESS15"] or {}

	local hourSum = 0

	if #businessHistory > 0 then
		for k, v in ipairs(businessHistory) do
			self.timeTable:AddLine(v["date"] or "", os.date("%I:%M %p", v["in"]), v["out"] and os.date("%I:%M %p", v["out"]) or "", v["hours"] or "")

			if v["hours"] then
				hourSum = hourSum + v["hours"]
			end
	
			hourSum = math.floor(hourSum*10)/10
		end
	end
end

vgui.Register("CWUTimeclock", PANEL, "EditablePanel")

PANEL = {}

DEFINE_BASECLASS("DFrame")

local screenMat = Material("models/props_combine/combine_light001a")
screenMat:SetString("$basetexture", "models/props_combine/combinescanline")
screenMat:SetInt("$additive", 0)
screenMat:SetInt("$mod2x", 1)
screenMat:SetUndefined("Proxies")

local animLength = 1.25

function PANEL:Init()
	self:SetSize(700, 450)
	self:Center()
	self:MakePopup()
	
	self.tempW = 1
	self.animationDone = false
	self.animStartTime = CurTime()

	self.contents = self:Add("Panel")
	self.contents:SetPos(0, 0)
	self.contents:SetSize(1, 450)
	self.contents:DockPadding(3, 3, 3, 3)

	self:ChangeScreen("mainMenu")

	local wholePanel = self

	local iteration = 1
	local function audioTimer()
		LocalPlayer():EmitSound("alyx/hacking/hacking_holo_appear_indv_"..Schema:ZeroNumber(math.random(1, 10), 2)..".wav")
		timer.Simple(math.Rand(0.25, 0.35), function()
			iteration = iteration + 1
			if iteration <= 4 then
				audioTimer()
			end
		end)
	end

	--LocalPlayer():EmitSound("alyx/hacking/hacking_sphere_appear_01.wav")

	audioTimer()

	self:CreateAnimation(animLength, {
		index = 1,
		target = {tempW = 700},
		easing = "inOutCubic",

		Think = function(animation, panel)
			panel.contents:SetWide(panel.tempW)
		end,

		OnComplete = function(animation, panel)
			self.animationDone = true
			
		end
	})

	
end

function PANEL:Close()
	net.Receive("prAptAction", function(len)
		local action = net.ReadUInt(32)

		if action == APTACT_OPEN then
			local aptSize = net.ReadUInt(32)
			local apartments = util.JSONToTable(util.Decompress(net.ReadData(aptSize)))
			ix.gui.debug = vgui.Create("ixApartmentManager")
			ix.gui.debug.buildingName = buildingName
			ix.gui.debug.apartments = apartments
		end
	end)

	self.tempW, self.tempH = self:GetSize()
	self:EmitSound("buttons/combine_button2.wav")

	self:CreateAnimation(0.5, {
		index = 3,
		target = {tempH = 3},
		easing = "inOutCirc",

		Think = function(animation, panel)
			panel:SetTall(panel.tempH)
			panel:SetY(ScrH()/2 - panel.tempH/2)
		end,

		OnComplete = function(animation, panel)
			panel:SetTall(3)
			panel:CreateAnimation(0.5, {
				index = 4,
				target = {tempW = 0},
				easing = "inOutCirc",

				Think = function(animation, panel)
					panel:SetWide(panel.tempW)
					panel:SetX(ScrW()/2 - panel.tempW/2)
				end,

				OnComplete = function(animation, panel)
					panel:SetWide(0)
					self:Remove()
				end
					
			})
		end
	})
end

function PANEL:EmitSound(soundPath)
	if !IsValid(self.player) then
		self.player = LocalPlayer()
	end

	self.player:EmitSound(soundPath)
end

function PANEL:ShowError(message)
	local guard = self:Add("Panel")
	guard:SetSize(0, 0, w, h)
	guard:SetPos(0, 0)

	local msgPanel = self:Add("DPanel")
	local pnlW, pnlH = 240, 100
	msgPanel:SetSize(pnlW, pnlH)
	msgPanel:SetPos(700/2 - pnlW/2, 500/2 - pnlH/2)
	msgPanel:DockPadding(7, 7, 7, 7)

	self:EmitSound("buttons/button8.wav")

	msgPanel.Paint = function(panel, w, h)
		surface.SetDrawColor(180, 0, 0)
		surface.DrawRect(0, 0, w, h)
		
		surface.SetDrawColor(color_white)
		surface.DrawOutlinedRect(3, 3, w - 6, h - 6, 1)
	end

	local msgHeading = msgPanel:Add("DLabel")
	msgHeading:SetText("ERROR")
	msgHeading:SizeToContents()
	msgHeading:Dock(TOP)
	msgHeading:SetContentAlignment(5)

	msgText = msgPanel:Add("DLabel")
	msgText:SetText(message)
	msgText:SizeToContents()
	local lblW, lblH = msgText:GetSize()

	msgText:SetPos(pnlW/2 - lblW/2, pnlH/2 - lblH/2)

	timer.Simple(2, function()
		if IsValid(msgPanel) then
			guard:Remove()
			msgPanel:Remove()
		end
	end)
end

function PANEL:ShowSuccess()
	local guard = self:Add("Panel")
	guard:SetSize(0, 0, w, h)
	guard:SetPos(0, 0)

	local msgPanel = self:Add("DPanel")
	local pnlW, pnlH = 240, 100
	msgPanel:SetSize(pnlW, pnlH)
	msgPanel:SetPos(700/2 - pnlW/2, 500/2 - pnlH/2)
	msgPanel:DockPadding(7, 7, 7, 7)

	self:EmitSound("buttons/button8.wav")

	msgPanel.Paint = function(panel, w, h)
		surface.SetDrawColor(0, 180, 0)
		surface.DrawRect(0, 0, w, h)
		
		surface.SetDrawColor(color_white)
		surface.DrawOutlinedRect(3, 3, w - 6, h - 6, 1)
	end

	local msgHeading = msgPanel:Add("DLabel")
	msgHeading:SetText("SUCCESS")
	msgHeading:SizeToContents()
	msgHeading:Dock(TOP)
	msgHeading:SetContentAlignment(5)

	msgText = msgPanel:Add("DLabel")
	msgText:SetText("Task completed successfully.")
	msgText:SizeToContents()
	local lblW, lblH = msgText:GetSize()

	msgText:SetPos(pnlW/2 - lblW/2, pnlH/2 - lblH/2)

	timer.Simple(2, function()
		if IsValid(msgPanel) then
			guard:Remove()
			msgPanel:Remove()
		end
	end)
end

function PANEL:ChangeScreen(screen)
	local mainPanel = self

	if IsValid(self.backBtn) then
		self.backBtn:Remove()
	end

	if IsValid(mainPanel.centerPanel) then
		mainPanel.centerPanel:Clear()
	end
	
	if screen != "mainMenu" then
		self.backBtn = mainPanel:Add("DButton")
		self.backBtn:SetPos(7, 450 - 30 - 3 - 39 - 2)
		self.backBtn:SetSize(60, 30)
		self.backBtn:SetText("Back")
		self.backBtn.DoClick = function(this)
			self:EmitSound("buttons/button15.wav")
			mainPanel:ChangeScreen("mainMenu")
			this:Remove()
		end
	end

	local screens = {
		["mainMenu"] = function()
			local bottomBar = mainPanel.contents:Add("Panel")
			
			bottomBar:SetPos(3, 450 - 36 - 3)
			bottomBar:SetSize(694, 36)
			
			local closeButton = bottomBar:Add("DButton")
			closeButton:Dock(RIGHT)
			closeButton:SetWide(60)
			closeButton:SetText("Log Out")

			closeButton.DoClick = function(panel)
				mainPanel:Close()
			end

			local topBar = self.contents:Add("DPanel")
			topBar:SetPos(3, 3)
			topBar:SetSize(694, 70)

			topBar:DockPadding(5, 5, 5, 5)
			bottomBar:DockPadding(3, 3, 3, 3)

			topBar.Paint = function(panel, w, h)
				surface.SetDrawColor(22, 22, 22)
				surface.DrawRect(0, 0, w, h)

				surface.SetDrawColor(63, 63, 63)
				surface.DrawLine(0, h - 1, w, h - 1)
			end

			bottomBar.Paint = function(panel, w, h)
				surface.SetDrawColor(22, 22, 22)
				surface.DrawRect(0, 0, w, h)

				surface.SetDrawColor(63, 63, 63)
				surface.DrawLine(0, 0, w, 0)
			end

			local buildingName = topBar:Add("DLabel")
			buildingName:SetText("UHB Collation")
			buildingName:SetFont("DermaLarge")
			buildingName:Dock(TOP)
			buildingName:SizeToContents()
			buildingName:DockMargin(0, 0, 0, 0)

			topBar:SetTall(buildingName:GetTall() + 8)

			mainPanel.centerPanel = mainPanel.contents:Add("Panel")
			mainPanel.centerPanel:SetPos(3 + 140, 70 + 3 - 18)
			mainPanel.centerPanel:SetSize(694 - 140*2, 450 - bottomBar:GetTall() - topBar:GetTall() - 42 + 18)
			mainPanel.centerPanel:DockPadding(50, 0, 50, 0)
			
			local buttons = {
				{
					text = "Assign Citizen to Apartment",
					DoClick = function(panel)
						self:EmitSound("buttons/button15.wav")
						mainPanel:ChangeScreen("addTenant")
					end
				},

				{
					text = "Revoke Apartment from Citizen",
					DoClick = function(panel)
						self:EmitSound("buttons/button15.wav")
						mainPanel:ChangeScreen("removeTenant")
					end
				},

				{
					text = "Print Key",
					DoClick = function(panel)
						self:EmitSound("buttons/button15.wav")
						mainPanel:ChangeScreen("printKey")
					end
				}
			}

			local callCitizens = mainPanel.centerPanel:Add("DButton")
			callCitizens:SetTall(42)
			callCitizens:Dock(BOTTOM)
			callCitizens:SetText("Call Residents to Building")
			callCitizens:SetTextColor(Color(203, 17, 17))
			callCitizens.DoClick = function(panel)
				net.Start("prAptAction")
					net.WriteUInt(APTACT_CALLRES, 32)
				net.SendToServer()
				
				net.Receive("prAptResponse", function(len)
					local action = net.ReadUInt(32)
					if action == APTACT_INVALIDTENANT then
						mainPanel:ShowError("That person is not a tenant here!")
					elseif action == APTACT_BADFACTION then
						mainPanel:ShowError("That person cannot be assigned an apartment!")
					elseif action == APTACT_ALREADYASSIGNED then
						mainPanel:ShowError("That person is already a tenant there!")
					elseif action == APACT_INVALIDINDV then
						mainPanel:ShowError("That person does not exist!")
					elseif action == APTACT_APTFULL then
						mainPanel:ShowError("That apartment is full!")
					elseif action == APTACT_INVALIDAPT then
						mainPanel:ShowError("That apartment is full!")
					elseif action == APTACT_SVSUCCESS then
						mainPanel:ChangeScreen("mainMenu")
						mainPanel:EmitSound("buttons/button15.wav")
						mainPanel:ShowSuccess()
						local aptSize = net.ReadUInt(32)
						local apartments = util.JSONToTable(util.Decompress(net.ReadData(aptSize)))
						ix.gui.debug.apartments = apartments
					else
						mainPanel:ShowError("An unknown error occured.")
					end
				end)
			end

			mainPanel.centerPanel.PaintOver = function(panel, w, h)
				surface.SetDrawColor(255, 0, 0, 100)
				--surface.DrawRect(0, 0, w, h)
			end
			
			for i = 1, #buttons do
				local data = buttons[#buttons - i + 1]
				local btn = self.centerPanel:Add("DButton")
				btn:SetTall(42)
				btn:Dock(BOTTOM)
				btn:DockMargin(0, 0, 0, 10)
				btn:SetText(data.text)
				btn.DoClick = data.DoClick
			end
		
			local img = mainPanel.centerPanel:Add("DImage")
			local sideMargin = mainPanel.centerPanel:GetWide()
			img:Dock(TOP)
			img:SetTall(104)
			img:DockMargin(sideMargin/2 - 102, 5, sideMargin/2 - 102, 0)
			img:SetImage("vgui/prlogo-400px.png")
		end,

		["addTenant"] = function()
			local iconSize = 42
			local iconSpace = 4
			local container = mainPanel.centerPanel
			local apartments = table.Copy(mainPanel.apartments)  

			local cidLbl = container:Add("DLabel")
			cidLbl:Dock(TOP)
			cidLbl:SetText("Citizen's CID")

			local cidEntry = container:Add("DTextEntry")
			cidEntry:Dock(TOP)
			cidEntry:SetTextColor(color_black)

			cidEntry:DockMargin(0, 0, 0, 20)

			local layoutLbl = container:Add("DLabel")
			layoutLbl:SetText("Select Apartment")
			layoutLbl:SetFont("DermaDefault")
			layoutLbl:SizeToContents()
			layoutLbl:Dock(TOP)
			layoutLbl:DockMargin(0, 0, 0, 10)

			local layout = container:Add("DTileLayout")
			layout:Dock(TOP)
			layout:SetSize(iconSpace + (iconSize + iconSpace)*4, iconSpace + (iconSize + iconSpace)*3)
			layout:SetPos(container:GetWide()/2 - layout:GetWide()/2, 150)
			layout:SetBaseSize(iconSize)
			layout:SetSpaceX(iconSpace)
			layout:SetSpaceY(iconSpace)

			layoutLbl:SetPos(layout:GetX(), layout:GetY() - 25)

			local marginTotal = (container:GetWide() - layout:GetWide())/2
			layout:DockMargin(marginTotal/2, 0, marginTotal/2, 0)

			local lastFloor = "1"

			apartments = table.ClearKeys(apartments)
			table.SortByMember(apartments, "name", true)

			local numFloors = 1
			for k, v in pairs(apartments) do
				if !string.StartWith(v.name, lastFloor) then
					lastFloor = string.sub(v.name, 1, 1)
					numFloors = numFloors + 1
				end


				local btn = layout:Add("DButton")
				btn:SetSize(iconSize, iconSize)
				btn:SetText("")
				btn:SetContentAlignment(5)

				btn.numTenants = #v.tenants
				btn.maxTenants = v.maxTenants

				btn.DoClick = function(panel)
					self:EmitSound("buttons/button15.wav")
					container.aptSelected = panel
				end

				btn.name = v.name

				btn.PaintOver = function(panel, w, h)
					if container.aptSelected == panel then
						if panel.full then 
							surface.SetDrawColor(255, 38, 0, 10)
						else
							surface.SetDrawColor(255, 255, 0, 10)
						end
						surface.DrawRect(1, 1, w - 2, h - 2)
					end

					local halfW = w/2
					draw.SimpleText(panel.name, nil, halfW, h*0.5 - 1, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
					draw.SimpleText(panel.numTenants.."/"..panel.maxTenants, nil, halfW, h*0.5 + 1, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				end
			end

			local submitBtn = container:Add("DButton")
			submitBtn:Dock(BOTTOM)
			submitBtn:SetTall(36)
			local contW = container:GetWide()
			submitBtn:DockMargin(contW/4, 0, contW/4, 0)
			submitBtn:SetText("Submit")

			submitBtn.DoClick = function()
			
				net.Receive("prAptResponse", function(len)
					local action = net.ReadUInt(32)
					if action == APTACT_INVALIDTENANT then
						mainPanel:ShowError("That person is not a tenant at this apartment!")
					elseif action == APTACT_BADFACTION then
						mainPanel:ShowError("That person cannot be assigned an apartment!")
					elseif action == APTACT_ALREADYASSIGNED then
						mainPanel:ShowError("That person is already a tenant there!")
					elseif action == APACT_INVALIDINDV then
						mainPanel:ShowError("That person does not exist!")
					elseif action == APTACT_APTFULL then
						mainPanel:ShowError("That apartment is full!")
					elseif action == APTACT_INVALIDAPT then
						mainPanel:ShowError("That apartment is full!")
					elseif action == APTACT_SVSUCCESS then
						mainPanel:ChangeScreen("mainMenu")
						mainPanel:EmitSound("buttons/button15.wav")
						mainPanel:ShowSuccess()
						local aptSize = net.ReadUInt(32)
						local apartments = util.JSONToTable(util.Decompress(net.ReadData(aptSize)))
						ix.gui.debug.apartments = apartments
					else
						mainPanel:ShowError("An unknown error occured.")
					end
				end)

				net.Start("prAptAction")
					net.WriteUInt(APTACT_ADDTENANT, 32)
					net.WriteString(string.sub(cidEntry:GetText(), 1, 5))
					print(string.sub(cidEntry:GetText(), 1, 5))
					net.WriteString(container.aptSelected and container.aptSelected.name or "")
				net.SendToServer()
			end
		end,
		
		["removeTenant"] = function()
			local iconSize = 42
			local iconSpace = 4
			local container = mainPanel.centerPanel
			local apartments = table.Copy(mainPanel.apartments)  

			local layoutLbl = container:Add("DLabel")
			layoutLbl:SetText("Select Apartment")
			layoutLbl:SetFont("DermaDefault")
			layoutLbl:SizeToContents()
			layoutLbl:Dock(TOP)
			layoutLbl:DockMargin(0, 0, 0, 10)
			
			local layout = container:Add("DTileLayout")
			layout:Dock(TOP)
			layout:SetSize(iconSpace + (iconSize + iconSpace)*4, iconSpace + (iconSize + iconSpace)*3)
			layout:SetPos(container:GetWide()/2 - layout:GetWide()/2, 150)
			layout:SetBaseSize(iconSize)
			layout:SetSpaceX(iconSpace)
			layout:SetSpaceY(iconSpace)

			layoutLbl:SetPos(layout:GetX(), layout:GetY() - 25)

			local marginTotal = (container:GetWide() - layout:GetWide())/2
			layout:DockMargin(marginTotal/2, 0, marginTotal/2, 0)

			local lastFloor = "1"

			apartments = table.ClearKeys(apartments)
			table.SortByMember(apartments, "name", true)

			local numFloors = 1
			for k, v in pairs(apartments) do
				if !string.StartWith(v.name, lastFloor) then
					lastFloor = string.sub(v.name, 1, 1)
					numFloors = numFloors + 1
				end


				local btn = layout:Add("DButton")
				btn:SetSize(iconSize, iconSize)
				btn:SetText("")
				btn:SetContentAlignment(5)

				btn.numTenants = #v.tenants
				btn.maxTenants = v.maxTenants

				btn.DoClick = function(panel)
					self:EmitSound("buttons/button15.wav")
					container.tenantList:Clear()
					PrintTable(v)
					for index, CID in ipairs(v.tenants) do
						container.tenantList:AddChoice(v.niceNames[index].." - "..CID, CID)
					end
					container.tenantList:SetValue("Choose Tenant")
					container.aptSelected = panel
				end

				btn.name = v.name

				btn.PaintOver = function(panel, w, h)
					if container.aptSelected == panel then
						if panel.full then 
							surface.SetDrawColor(255, 38, 0, 10)
						else
							surface.SetDrawColor(255, 255, 0, 10)
						end
						surface.DrawRect(1, 1, w - 2, h - 2)
					end

					local halfW = w/2
					draw.SimpleText(panel.name, nil, halfW, h*0.5 - 1, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
					draw.SimpleText(panel.numTenants.."/"..panel.maxTenants, nil, halfW, h*0.5 + 1, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				end
			end

			local tenantLbl = container:Add("DLabel")
			tenantLbl:SetText("Select Tenant")
			tenantLbl:SetFont("DermaDefault")
			tenantLbl:SizeToContents()
			tenantLbl:Dock(TOP)
			tenantLbl:DockMargin(0, 10, 0, 10)
			
			container.tenantList = container:Add("DComboBox")
			container.tenantList:Dock(TOP)
			container.tenantList:DockMargin(0, 0, 0, 10)
			container.tenantList:SetValue("")

			local submitBtn = container:Add("DButton")
			submitBtn:Dock(BOTTOM)
			submitBtn:SetTall(36)
			local contW = container:GetWide()
			submitBtn:DockMargin(contW/4, 0, contW/4, 0)
			submitBtn:SetText("Submit")

			submitBtn.DoClick = function()
			
				net.Receive("prAptResponse", function(len)
					local action = net.ReadUInt(32)
					if action == APTACT_INVALIDTENANT then
						mainPanel:ShowError("That person is not a tenant at this apartment!")
					elseif action == APTACT_BADFACTION then
						mainPanel:ShowError("That person cannot be assigned an apartment!")
					elseif action == APTACT_ALREADYASSIGNED then
						mainPanel:ShowError("That person is already a tenant there!")
					elseif action == APACT_INVALIDINDV then
						mainPanel:ShowError("That person does not exist!")
					elseif action == APTACT_APTFULL then
						mainPanel:ShowError("That apartment is full!")
					elseif action == APTACT_INVALIDAPT then
						mainPanel:ShowError("That apartment is full!")
					elseif action == APTACT_SVSUCCESS then
						mainPanel:ChangeScreen("mainMenu")
						mainPanel:EmitSound("buttons/button15.wav")
						mainPanel:ShowSuccess()
						local aptSize = net.ReadUInt(32)
						local apartments = util.JSONToTable(util.Decompress(net.ReadData(aptSize)))
						ix.gui.debug.apartments = apartments
					else
						mainPanel:ShowError("An unknown error occured.")
					end
				end)

				local text, CID = container.tenantList:GetSelected()

				net.Start("prAptAction")
					net.WriteUInt(APTACT_REMOVETENANT, 32)
					net.WriteString(CID)
					net.WriteString(container.aptSelected and container.aptSelected.name or "")
				net.SendToServer()
			end
		end,

		["printKey"] = function()
			local iconSize = 42
			local iconSpace = 4
			local container = mainPanel.centerPanel
			local apartments = table.Copy(mainPanel.apartments)  

			local layoutLbl = container:Add("DLabel")
			layoutLbl:SetText("Select Apartment")
			layoutLbl:SetFont("DermaDefault")
			layoutLbl:SizeToContents()
			layoutLbl:Dock(TOP)
			layoutLbl:DockMargin(0, 0, 0, 10)
			
			local layout = container:Add("DTileLayout")
			layout:SetSize(iconSpace + (iconSize + iconSpace)*4, iconSpace + (iconSize + iconSpace)*3)
			layout:SetPos(container:GetWide()/2 - layout:GetWide()/2, 150)
			layout:Dock(TOP)
			layout:SetBaseSize(iconSize)
			layout:SetSpaceX(iconSpace)
			layout:SetSpaceY(iconSpace)

			--layoutLbl:SetPos(layout:GetX(), layout:GetY() - 25)

			local marginTotal = (container:GetWide() - layout:GetWide())/2
			layout:DockMargin(marginTotal/2, 0, marginTotal/2, 0)
			layoutLbl:DockMargin(0, marginTotal/2, 0, 10)

			local lastFloor = "1"

			apartments = table.ClearKeys(apartments)
			table.SortByMember(apartments, "name", true)

			local numFloors = 1
			for k, v in pairs(apartments) do
				if !string.StartWith(v.name, lastFloor) then
					lastFloor = string.sub(v.name, 1, 1)
					numFloors = numFloors + 1
				end


				local btn = layout:Add("DButton")
				btn:SetSize(iconSize, iconSize)
				btn:SetText("")
				btn:SetContentAlignment(5)

				btn.numTenants = #v.tenants
				btn.maxTenants = v.maxTenants

				btn.DoClick = function(panel)
					self:EmitSound("buttons/button15.wav")
					container.aptSelected = panel
				end

				btn.name = v.name

				btn.PaintOver = function(panel, w, h)
					if container.aptSelected == panel then
						if panel.full then 
							surface.SetDrawColor(255, 38, 0, 10)
						else
							surface.SetDrawColor(255, 255, 0, 10)
						end
						surface.DrawRect(1, 1, w - 2, h - 2)
					end

					local halfW = w/2
					draw.SimpleText(panel.name, nil, halfW, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
			end


			local submitBtn = container:Add("DButton")
			submitBtn:Dock(BOTTOM)
			submitBtn:SetTall(36)
			local contW = container:GetWide()
			submitBtn:DockMargin(contW/4, 0, contW/4, 0)
			submitBtn:SetText("Print")

			submitBtn.DoClick = function()
			
				net.Receive("prAptResponse", function(len)
					local action = net.ReadUInt(32)
					if action == APTACT_INVALIDTENANT then
						mainPanel:ShowError("That person is not a tenant at this apartment!")
					elseif action == APTACT_BADFACTION then
						mainPanel:ShowError("That person cannot be assigned an apartment!")
					elseif action == APTACT_ALREADYASSIGNED then
						mainPanel:ShowError("That person is already a tenant there!")
					elseif action == APACT_INVALIDINDV then
						mainPanel:ShowError("That person does not exist!")
					elseif action == APTACT_APTFULL then
						mainPanel:ShowError("That apartment is full!")
					elseif action == APTACT_INVALIDAPT then
						mainPanel:ShowError("That apartment is full!")
					elseif action == APTACT_SVSUCCESS then
						mainPanel:ChangeScreen("mainMenu")
						mainPanel:EmitSound("buttons/button15.wav")
						mainPanel:ShowSuccess()
						local aptSize = net.ReadUInt(32)
						local apartments = util.JSONToTable(util.Decompress(net.ReadData(aptSize)))
						ix.gui.debug.apartments = apartments
					else
						mainPanel:ShowError("An unknown error occured.")
					end
				end)

				net.Start("prAptAction")
					net.WriteUInt(APTACT_PRINTKEY, 32)
					net.WriteString(container.aptSelected and container.aptSelected.name or "")
				net.SendToServer()
			end

		end
	}

	screens[screen]()
end

local panelW, panelH = 700, 450
local halfW, halfH = panelW/2, panelH/2 
local innerBoxW, innerBoxH = 50, 32
local halfLowW, halfLowH, halfHighW, halfHighH = halfW - innerBoxW, halfH - innerBoxH, halfW + innerBoxW, halfH + innerBoxH

local bgLines = {
	{halfLowW, halfLowH, halfLowW, halfHighH},
	{halfLowW, halfLowH, halfHighW, halfLowH},
	{halfLowW, halfHighH, halfHighW, halfHighH},
	{halfHighW, halfLowH, halfHighW, halfHighH},
	{0, 0, halfLowW, halfLowH},
	{0, panelH, halfLowW, halfHighH},
	{panelW, 0, halfHighW, halfLowH},
	{panelW, panelH, halfHighW, halfHighH}
}

function PANEL:Paint(w, h)
	if self.animationDone then
		surface.SetDrawColor(25, 25, 25)
		surface.DrawRect(0, 0, w, h)
	else 
		local curTime = CurTime()

		local animFrac = animLength/4.5
		local timeFrac = ((curTime - self.animStartTime)/(animLength))
		local cornerTL = Lerp(math.ease.InOutCubic(timeFrac), 0, panelW)

		if timeFrac <= animFrac then
			surface.SetDrawColor(255, 255, 0)
		elseif timeFrac <= animFrac*2 then
			surface.SetDrawColor(0, 255, 255)
		elseif timeFrac <= animFrac*3 then
			surface.SetDrawColor(255, 0, 255)
		else
			surface.SetDrawColor(255, 255, 255)
		end

		for k, v in ipairs(bgLines) do
			surface.DrawLine(v[1], v[2], v[3], v[4])
		end

		surface.DrawOutlinedRect(0, 0, w, h, 1)

		surface.SetDrawColor(25, 25, 25)
		surface.DrawRect(0, 0, cornerTL, h)

		surface.SetDrawColor(208, 208, 208)
		surface.DrawOutlinedRect(0, 0, cornerTL, h, 3)
	end
end

function PANEL:PaintOver(w, h)
	if self.animationDone then
		surface.SetDrawColor(208, 208, 208)
		surface.DrawOutlinedRect(0, 0, w, h, 3)
	else
		local curTime = CurTime()

		local timeFrac = ((curTime - self.animStartTime)/(animLength))
		local easeFrac = math.ease.InOutCubic(timeFrac)
		local cornerTL = Lerp(easeFrac, 0, panelW)
		local halfLowW, halfLowH, halfHighW, halfHighH = halfW - innerBoxW, halfH - innerBoxH, halfW + innerBoxW, halfH + innerBoxH
		local cornerInner = Lerp(easeFrac, halfLowW, halfHighW)

		local verts = {}

		surface.SetDrawColor(35, 174, 255, 150)
		draw.NoTexture()
		if cornerTL < halfW then
			verts = {
				{x = cornerTL, y = 0},
				{x = cornerInner, y = halfLowH},
				{x = cornerInner, y = halfHighH},
				{x = cornerTL, y = panelH}
			}
			surface.DrawPoly(verts)
		end
		
		
		

		surface.SetDrawColor(35, 174, 255, 255)
		surface.DrawRect(cornerTL - 5, 0, 5, panelH)
	end
end


vgui.Register("ixApartmentManager", PANEL, "EditablePanel")

PANEL = {}

function PANEL:Init()
	self:SetSize(400, 112)
	self:Center()
	self:MakePopup()
	self:SetTitle("Radio Controls")

	local freqBar = self:Add("Panel")
	freqBar:Dock(TOP)
	freqBar:SetTall(15)

	local freqLabel = freqBar:Add("DLabel")
	freqLabel:Dock(LEFT)
	freqLabel:SetText("Frequency")
	
	self.freqEntry = freqBar:Add("ixTextEntry")
	self.freqEntry:Dock(RIGHT)
	self.freqEntry:SetWide(220)
	self.freqEntry:DockMargin(0, 0, 0, 0)
	self.freqEntry:SetContentAlignment(9)
	self.freqEntry:SetNumeric(true)

	self.volumeSlider = self:Add("DNumSlider")
	self.volumeSlider:Dock(TOP)
	self.volumeSlider:SetMinMax(0, 100)
	self.volumeSlider:SetContentAlignment(4)
	self.volumeSlider:SetText("Volume")
	self.volumeSlider:SetDecimals(0)

	local bottomBar = self:Add("Panel")
	bottomBar:Dock(BOTTOM)
	bottomBar:SetTall(26)

	local bottomLeft = bottomBar:Add("Panel")
	bottomLeft:Dock(LEFT)
	bottomLeft:SetWide(self:GetWide()/2)
	bottomLeft:DockPadding(0, 0, 7, 0)

	local bottomRight = bottomBar:Add("Panel")
	bottomRight:SetWide(self:GetWide()/2)
	bottomRight:Dock(RIGHT)
	bottomRight:DockPadding(7, 0, 0, 0)

	local submitButton = bottomLeft:Add("DButton")
	submitButton:Dock(RIGHT)
	submitButton:SetWide(80)
	submitButton:SetText("Submit")
	submitButton.DoClick = function(panel)
		net.Start("ixRadioOptSubmit")
			net.WriteString(self.freqEntry:GetValue())
			net.WriteInt(math.Round(self.volumeSlider:GetValue()), 32)
		net.SendToServer()

		self:Remove()
	end
	
	local cancelButton = bottomRight:Add("DButton")
	cancelButton:Dock(LEFT)
	cancelButton:SetWide(80)
	cancelButton:SetText("Cancel")
	cancelButton.DoClick = function(panel)
		self:Remove()
	end
end

function PANEL:Populate(frequency, volume)
	self.freqEntry:SetValue(frequency)
	self.volumeSlider:SetValue(volume)
end

vgui.Register("ixRadioEntMenu", PANEL, "DFrame")

PANEL = {}

DEFINE_BASECLASS("DFrame")

local screenMat = Material("models/props_combine/combine_light001a")
screenMat:SetString("$basetexture", "models/props_combine/combinescanline")
screenMat:SetInt("$additive", 0)
screenMat:SetInt("$mod2x", 1)
screenMat:SetUndefined("Proxies")

local animLength = 1.25

function PANEL:Init()
	self:SetSize(700, 450)
	self:Center()
	self:MakePopup()
	
	self.tempW = 1
	self.animationDone = false
	self.animStartTime = CurTime()

	self.contents = self:Add("Panel")
	self.contents:SetPos(0, 0)
	self.contents:SetSize(1, 450)
	self.contents:DockPadding(3, 3, 3, 3)

	self:ChangeScreen("mainMenu")

	local wholePanel = self

	local iteration = 1
	local function audioTimer()
		LocalPlayer():EmitSound("alyx/hacking/hacking_holo_appear_indv_"..Schema:ZeroNumber(math.random(1, 10), 2)..".wav")
		timer.Simple(math.Rand(0.25, 0.35), function()
			iteration = iteration + 1
			if iteration <= 4 then
				audioTimer()
			end
		end)
	end

	--LocalPlayer():EmitSound("alyx/hacking/hacking_sphere_appear_01.wav")

	audioTimer()

	self:CreateAnimation(animLength, {
		index = 1,
		target = {tempW = 700},
		easing = "inOutCubic",

		Think = function(animation, panel)
			panel.contents:SetWide(panel.tempW)
		end,

		OnComplete = function(animation, panel)
			self.animationDone = true
			
		end
	})

	
end

function PANEL:Close()
	net.Receive("prAptAction", function(len)
		local action = net.ReadUInt(32)

		if action == APTACT_OPEN then
			local aptSize = net.ReadUInt(32)
			local apartments = util.JSONToTable(util.Decompress(net.ReadData(aptSize)))
			ix.gui.debug = vgui.Create("ixApartmentManager")
			ix.gui.debug.buildingName = buildingName
			ix.gui.debug.apartments = apartments
		end
	end)

	self.tempW, self.tempH = self:GetSize()
	self:EmitSound("buttons/combine_button2.wav")

	self:CreateAnimation(0.5, {
		index = 3,
		target = {tempH = 3},
		easing = "inOutCirc",

		Think = function(animation, panel)
			panel:SetTall(panel.tempH)
			panel:SetY(ScrH()/2 - panel.tempH/2)
		end,

		OnComplete = function(animation, panel)
			panel:SetTall(3)
			panel:CreateAnimation(0.5, {
				index = 4,
				target = {tempW = 0},
				easing = "inOutCirc",

				Think = function(animation, panel)
					panel:SetWide(panel.tempW)
					panel:SetX(ScrW()/2 - panel.tempW/2)
				end,

				OnComplete = function(animation, panel)
					panel:SetWide(0)
					self:Remove()
				end
					
			})
		end
	})
end

function PANEL:EmitSound(soundPath)
	if !IsValid(self.player) then
		self.player = LocalPlayer()
	end

	self.player:EmitSound(soundPath)
end

function PANEL:ShowError(message)
	local guard = self:Add("Panel")
	guard:SetSize(0, 0, w, h)
	guard:SetPos(0, 0)

	local msgPanel = self:Add("DPanel")
	local pnlW, pnlH = 240, 100
	msgPanel:SetSize(pnlW, pnlH)
	msgPanel:SetPos(700/2 - pnlW/2, 500/2 - pnlH/2)
	msgPanel:DockPadding(7, 7, 7, 7)

	self:EmitSound("buttons/button8.wav")

	msgPanel.Paint = function(panel, w, h)
		surface.SetDrawColor(180, 0, 0)
		surface.DrawRect(0, 0, w, h)
		
		surface.SetDrawColor(color_white)
		surface.DrawOutlinedRect(3, 3, w - 6, h - 6, 1)
	end

	local msgHeading = msgPanel:Add("DLabel")
	msgHeading:SetText("ERROR")
	msgHeading:SizeToContents()
	msgHeading:Dock(TOP)
	msgHeading:SetContentAlignment(5)

	msgText = msgPanel:Add("DLabel")
	msgText:SetText(message)
	msgText:SizeToContents()
	local lblW, lblH = msgText:GetSize()

	msgText:SetPos(pnlW/2 - lblW/2, pnlH/2 - lblH/2)

	timer.Simple(2, function()
		if IsValid(msgPanel) then
			guard:Remove()
			msgPanel:Remove()
		end
	end)
end

function PANEL:ShowSuccess()
	local guard = self:Add("Panel")
	guard:SetSize(0, 0, w, h)
	guard:SetPos(0, 0)

	local msgPanel = self:Add("DPanel")
	local pnlW, pnlH = 240, 100
	msgPanel:SetSize(pnlW, pnlH)
	msgPanel:SetPos(700/2 - pnlW/2, 500/2 - pnlH/2)
	msgPanel:DockPadding(7, 7, 7, 7)

	self:EmitSound("buttons/button8.wav")

	msgPanel.Paint = function(panel, w, h)
		surface.SetDrawColor(0, 180, 0)
		surface.DrawRect(0, 0, w, h)
		
		surface.SetDrawColor(color_white)
		surface.DrawOutlinedRect(3, 3, w - 6, h - 6, 1)
	end

	local msgHeading = msgPanel:Add("DLabel")
	msgHeading:SetText("SUCCESS")
	msgHeading:SizeToContents()
	msgHeading:Dock(TOP)
	msgHeading:SetContentAlignment(5)

	msgText = msgPanel:Add("DLabel")
	msgText:SetText("Task completed successfully.")
	msgText:SizeToContents()
	local lblW, lblH = msgText:GetSize()

	msgText:SetPos(pnlW/2 - lblW/2, pnlH/2 - lblH/2)

	timer.Simple(2, function()
		if IsValid(msgPanel) then
			guard:Remove()
			msgPanel:Remove()
		end
	end)
end

function PANEL:ChangeScreen(screen)
	local mainPanel = self
	mainPanel:DockPadding(7, 5, 5, 5)

	if IsValid(self.backBtn) then
		self.backBtn:Remove()
	end

	if self.animationDone and screen != "mainMenu"then
		mainPanel:Clear()
	end
	
	if screen != "mainMenu" then
		self.backBtn = mainPanel:Add("DButton")
		self.backBtn:SetPos(7, 450 - 30 - 3 - 39 - 2)
		self.backBtn:SetSize(60, 30)
		self.backBtn:SetText("Back")
		self.backBtn.DoClick = function(this)
			self:EmitSound("buttons/button15.wav")
			mainPanel:ChangeScreen("mainMenu")
			this:Remove()
		end
	end

	local screens = {
		["mainMenu"] = function()
			mainPanel:DockPadding(7, 5, 5, 5)
			local label = mainPanel.contents:Add("DLabel")
			

			label:SetFont("DermaLarge")
			label:SetText("Citizen Access Point")
			label:SizeToContents()
			label:SetContentAlignment(5)

			label:SetPos(mainPanel:GetWide()/2 - label:GetWide()/2, 5)

			local buttons = {
				{
					text = "Messages",
					DoClick = function(panel)
						self:EmitSound("buttons/button15.wav")
						mainPanel:ChangeScreen("messages")
					end
				},

				{
					text = "Apartment Management",
					DoClick = function(panel)
						self:EmitSound("buttons/button15.wav")
						LocalPlayer():Notify("That is not implemented yet!")
						--mainPanel:ChangeScreen("removeTenant")
					end
				},

				{
					text = "View Data",
					DoClick = function(panel)
						self:EmitSound("buttons/button15.wav")
						LocalPlayer():Notify("That is not implemented yet!")
					end
				},
			}
			
			-- necessary functionality
			-- check data
			--	- LP
			--  - Apartment
			--  - Join Date
			--  - Civil Status
			-- sending messages
			-- apartments

			local btnGrid = mainPanel.contents:Add("DGrid")
			btnGrid:SetPos(0, label:GetTall() + 10)
			
			btnGrid:SetCols(2)

			local btnW = btnGrid:GetWide()/2 - 8
			local btnH = 40

			for i = 1, #buttons do
				local data = buttons[#buttons - i + 1]
				local btn = mainPanel.contents:Add("DButton")
				btn:SetTall(42)
				btnGrid:SetColWide(mainPanel:GetWide()/2 - 10)
				btnGrid:SetRowHeight(42 + 8)
				btn:SetWide(btnGrid:GetColWide())
				if i%2 == 1 then btn:SetWide(btn:GetWide() - 5) end
				btn:SetText(data.text)
				btn.DoClick = data.DoClick
				btnGrid:AddItem(btn)
			end

			btnGrid:SetWide(2*btnGrid:GetColWide())
			
			btnGrid:SetX(350 - btnGrid:GetWide()/2, mainPanel:GetTall()/2 - btnGrid:GetTall()/2)

			local btn = mainPanel.contents:Add("DButton")
			btn:SetTall(42)
			btn:SetWide(btnGrid:GetColWide())
			btn:SetText("Log Out")
			btn.DoClick = function() self:Remove() end
			btn:SetPos(mainPanel:GetWide()/2 - btn:GetWide()/2, mainPanel:GetTall() - 10 - 42)

		end,
		["messages"] = function()
			mainPanel:DockPadding(2, 2, 2, 2)
			local pnl = mainPanel:Add("ixMessenger")
			pnl:Dock(FILL)
		end
	}


	screens[screen]()
end

local panelW, panelH = 700, 450
local halfW, halfH = panelW/2, panelH/2 
local innerBoxW, innerBoxH = 50, 32
local halfLowW, halfLowH, halfHighW, halfHighH = halfW - innerBoxW, halfH - innerBoxH, halfW + innerBoxW, halfH + innerBoxH

local bgLines = {
	{halfLowW, halfLowH, halfLowW, halfHighH},
	{halfLowW, halfLowH, halfHighW, halfLowH},
	{halfLowW, halfHighH, halfHighW, halfHighH},
	{halfHighW, halfLowH, halfHighW, halfHighH},
	{0, 0, halfLowW, halfLowH},
	{0, panelH, halfLowW, halfHighH},
	{panelW, 0, halfHighW, halfLowH},
	{panelW, panelH, halfHighW, halfHighH}
}

function PANEL:Paint(w, h)
	if self.animationDone then
		surface.SetDrawColor(35, 47, 35)
		surface.DrawRect(0, 0, w, h)
	else 
		local curTime = CurTime()

		local animFrac = animLength/4.5
		local timeFrac = ((curTime - self.animStartTime)/(animLength))
		local cornerTL = Lerp(math.ease.InOutCubic(timeFrac), 0, panelW)

		if timeFrac <= animFrac then
			surface.SetDrawColor(255, 255, 0)
		elseif timeFrac <= animFrac*2 then
			surface.SetDrawColor(0, 255, 255)
		elseif timeFrac <= animFrac*3 then
			surface.SetDrawColor(255, 0, 255)
		else
			surface.SetDrawColor(255, 255, 255)
		end

		for k, v in ipairs(bgLines) do
			surface.DrawLine(v[1], v[2], v[3], v[4])
		end

		surface.DrawOutlinedRect(0, 0, w, h, 1)

		surface.SetDrawColor(35, 47, 35)
		surface.DrawRect(0, 0, cornerTL, h)

		surface.SetDrawColor(192, 191, 191)
		surface.DrawOutlinedRect(0, 0, cornerTL, h, 3)
	end
end

function PANEL:PaintOver(w, h)
	if self.animationDone then
		surface.SetDrawColor(208, 208, 208)
		surface.DrawOutlinedRect(0, 0, w, h, 3)
	else
		local curTime = CurTime()

		local timeFrac = ((curTime - self.animStartTime)/(animLength))
		local easeFrac = math.ease.InOutCubic(timeFrac)
		local cornerTL = Lerp(easeFrac, 0, panelW)
		local halfLowW, halfLowH, halfHighW, halfHighH = halfW - innerBoxW, halfH - innerBoxH, halfW + innerBoxW, halfH + innerBoxH
		local cornerInner = Lerp(easeFrac, halfLowW, halfHighW)

		local verts = {}

		surface.SetDrawColor(35, 174, 255, 150)
		draw.NoTexture()
		if cornerTL < halfW then
			verts = {
				{x = cornerTL, y = 0},
				{x = cornerInner, y = halfLowH},
				{x = cornerInner, y = halfHighH},
				{x = cornerTL, y = panelH}
			}
			surface.DrawPoly(verts)
		end
		
		
		

		surface.SetDrawColor(35, 174, 255, 255)
		surface.DrawRect(cornerTL - 5, 0, 5, panelH)
	end
end


vgui.Register("ixCitizenTerminal", PANEL, "EditablePanel")

if IsValid(ix.gui.debug) then
	ix.gui.debug:Remove()
end

PANEL = {}

function PANEL:Init()
	--self:SetSkin("icterminal")

	self.loading = true
	self.loadingMat = Material("gamepadui/spinner")

	self.loadingGuard = self:Add("Panel")
	self.loadingGuard:Dock(FILL)

	net.Start("prMessengerAction")
		net.WriteUInt(MSG_OPEN, 32)
	net.SendToServer()

	net.Receive("prMessengerResponse", function()
		local codeOverride = net.ReadInt(32)

		if codeOverride == MSG_OPEN then
			local inboxSize = net.ReadInt(32)
			local inbox = net.ReadData(inboxSize)
			inbox = util.Decompress(inbox)
			inbox = util.JSONToTable(inbox)

			local outboxSize = net.ReadInt(32)
			local outbox = net.ReadData(outboxSize)
			outbox = util.Decompress(outbox)
			outbox = util.JSONToTable(outbox)

			self.inbox = inbox

			if !self.msgButtons  then
				self:LoadMessages(inbox)
			else
				if self.showingInbox then
					self:ShowInbox()
				else
					self.ShowOutbox()
				end
			end

			self.outbox = outbox

			timer.Simple(1 + math.Rand(0.3, 0.99), function()
				if IsValid(self) then
					self.loading = false
					self.loadingGuard:Remove()
				end
			end)

			return

		end

		if codeOverride == MSG_SEND then
			self:ClearMessage()
			return
		end
		
		local success = net.ReadBool()
		local message = net.ReadString()

		self:ShowMessageBox(message, success)
	end)
	

	self.buttonSkin = function(panel, w, h)
		surface.SetDrawColor(color_white)
		surface.DrawRect(0, 0, w, h)

		surface.SetDrawColor(color_black)
		surface.DrawOutlinedRect(0, 0, w, h, 1)

		surface.SetDrawColor(0, 0, 0, 50)
		if panel:IsHovered() then
			surface.DrawRect(0, 0, w, h)
		end

		if panel:IsDown() then
			surface.DrawRect(0, 0, w, h)
		end
	end

	local topBar = self:Add("Panel")
	topBar:Dock(TOP)
	topBar:SetTall(28)
	topBar.Paint = function(panel, w, h)
		surface.SetDrawColor(70, 88, 70)
		surface.DrawRect(0, 0, w, h)
		
		surface.SetDrawColor(color_black)
		surface.DrawLine(0, h - 1, w, h - 1) 
	end
	topBar:DockPadding(4, 4, 4, 4)

	local backBtn = topBar:Add("DButton")
	backBtn:Dock(LEFT)
	backBtn:SetWide(50)
	backBtn:SetTextColor(color_black)
	backBtn.Paint = self.buttonSkin
	backBtn:SetText("Back")
	backBtn.DoClick = function()
		self:Logout()
	end

	local composeBtn = topBar:Add("DButton")
	composeBtn:Dock(RIGHT)
	composeBtn:SetWide(98)
	composeBtn:SetTextColor(color_black)
	composeBtn.Paint = self.buttonSkin
	composeBtn:SetText("New Message")
	composeBtn.DoClick = function()
		self:WriteMessage()
	end

	local nameBtn = topBar:Add("DButton")
	nameBtn:Dock(RIGHT)
	nameBtn:SetWide(98)
	nameBtn:SetTextColor(color_black)
	nameBtn.Paint = self.buttonSkin
	nameBtn:SetText("Set Display Name")
	nameBtn.DoClick = function()
		local popup = self:Add("DFrame")
		popup:SetPos(self:GetWide()/2 - 200, self:GetTall()/2 - 50)
		popup:SetSize(400, 100)
		popup:SetTitle("Set Display Name")
		popup:SetSkin("icterminal")
		popup:ShowCloseButton(false)

		local label = popup:Add("DLabel")
		label:Dock(TOP)
		label:SetContentAlignment(5)
		label:SetText("Enter your new display name.")
		label:SetTextColor(color_black)
		label:DockMargin(0, 0, 0, 0)

		local entry = popup:Add("DTextEntry")
		entry:Dock(TOP)
		entry:DockMargin(0, 0, 0, -2)
		local bBar = popup:Add("Panel")
		bBar:Dock(BOTTOM)
		bBar:SetTall(18)
		bBar:DockMargin(0, 0, 0, 2)

		local bgColor = Color(12, 201, 250)	

		local bLeft = bBar:Add("Panel")
		bLeft:SetWide(popup:GetWide()/2 - 3*2)
		local bRight = bBar:Add("Panel")
		bLeft:Dock(LEFT)
		bRight:Dock(RIGHT)
		bRight:SetWide(bLeft:GetWide())

		local cBtn = bRight:Add("DButton")
		cBtn:Dock(LEFT)
		cBtn:SetText("Cancel")
		cBtn:SetTextColor(color_black)
		cBtn.DoClick = function(panel)
			popup:Remove()
		end

		local sBtn = bLeft:Add("DButton")
		sBtn:SetText("Submit")
		sBtn:Dock(RIGHT)
		sBtn:SetTextColor(color_black)
		sBtn.DoClick = function(panel)
			net.Start("prMessengerAction")
				net.WriteUInt(MSG_SETNAME, 32)
				net.WriteString(entry:GetValue(), 0, 32)
			net.SendToServer()
			popup:Remove()
		end

		
	end

	nameBtn:DockMargin(0, 0, 2, 0)

	local leftBar = self:Add("Panel")
	leftBar:Dock(LEFT)
	leftBar:SetWide(150)

	local listBar = leftBar:Add("Panel")
	listBar:Dock(TOP)
	listBar:SetTall(24)
	listBar:DockPadding(4, 2, 4, 3)

	self.showingInbox = true

	self.inboxBtn = listBar:Add("DButton")
	self.inboxBtn:Dock(LEFT)
	self.inboxBtn:SetWide(44)
	self.inboxBtn:SetText("Inbox")
	self.inboxBtn:DockMargin(0, 0, 2, 0)
	self.inboxBtn:SetTextColor(color_black)
	self.inboxBtn.Paint = function(panel, w, h)
		if self.showingInbox then
			surface.SetDrawColor(169, 169, 169)
			surface.DrawRect(0, 0, w, h)

			surface.SetDrawColor(color_black)
			surface.DrawOutlinedRect(0, 0, w, h, 1)
			return
		end
		
		self.buttonSkin(panel, w, h)
	end

	self.inboxBtn.DoClick = function(panel)
		self.showingInbox = true
		self.sentBtn.selected = false
		self:ShowInbox()
	end

	self.sentBtn = listBar:Add("DButton")
	self.sentBtn:Dock(LEFT)
	self.sentBtn:SetWide(44)
	self.sentBtn:SetText("Outbox")
	self.sentBtn:SetTextColor(color_black)
	self.sentBtn.Paint = function(panel, w, h)
		if !self.showingInbox then
			surface.SetDrawColor(169, 169, 169)
			surface.DrawRect(0, 0, w, h)

			surface.SetDrawColor(color_black)
			surface.DrawOutlinedRect(0, 0, w, h, 1)
			return
		end

		self.buttonSkin(panel, w, h)
	end

	self.sentBtn.DoClick = function(panel)
		self.showingInbox = false
		self.inboxBtn.selected = false
		self:ShowOutbox()
	end

	self.msgList = leftBar:Add("DScrollPanel")
	self.msgList:Dock(FILL)
	self.msgList.Paint = function(panel, w, h)
		surface.SetDrawColor(57, 69, 57)
		surface.DrawRect(0, 0, w, h)

		if !panel:GetVBar().Enabled then
			surface.SetDrawColor(139, 139, 139)
			surface.DrawRect(w - 15, 0, 15, h)
		end
		--surface.SetDrawColor(color_black)
		--surface.DrawOutlinedRect(0, 1, w - 1, h - 2, 2)
	end

	local sbar = self.msgList:GetVBar()

	sbar:SetHideButtons(true)
	
	function sbar:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(114, 114, 114, 100))
	end
	
	function sbar.btnGrip:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(138, 138, 138))
	end


	self.msgDisp = self:Add("EditablePanel")
	self.msgDisp:Dock(FILL)
	self.msgDisp.Paint = function(panel, w, h)
		surface.SetDrawColor(180, 180, 180)
		surface.DrawRect(0, 0, w, h)
		--surface.SetDrawColor(color_black)
		--surface.DrawOutlinedRect(0, 1, w - 1, h - 2, 2)
	end
	

	--self:ShowMessage("Test message text", "Test", "UU-SeC.17", os.time() - 3600*24*31)

	timer.Simple(1.5, function()
		if IsValid(self) then
			self:InvalidateParent()
		end
	end)
end

function PANEL:Paint(w, h)
	if !self.loading then
		surface.SetDrawColor(35, 47, 35)
		surface.DrawRect(0, 0, w, h)
	end
end

function PANEL:ShowMessageBox(message, success)
	local popup = self:Add("DFrame")
	popup:SetSize(400, 78)

	surface.SetFont("DermaDefault")
	local textW, textH = surface.GetTextSize(message)
	if textW >= 380 then
		popup:SetWide(textW + 20)
	end

	popup:SetPos(self:GetWide()/2 - popup:GetWide()/2, self:GetTall()/2 - popup:GetTall()/2)
	
	popup:SetTitle(success and "Success" or "Error")
	popup:SetSkin("icterminal")
	popup:ShowCloseButton(false)

	local label = popup:Add("DLabel")
	label:Dock(TOP)
	label:SetContentAlignment(5)
	label:SetText(message)
	label:SetTextColor(color_black)
	label:DockMargin(0, 0, 0, 0)

	local bgColor = Color(12, 201, 250)	

	local cBtn = popup:Add("DButton")
	cBtn:SetWide(58)
	cBtn:SetTall(18)
	cBtn:SetPos(popup:GetWide()/2 - cBtn:GetWide()/2, popup:GetTall() - cBtn:GetTall() - 9)
	cBtn:SetText("OK")
	cBtn:SetTextColor(color_black)
	cBtn.DoClick = function(panel)
		popup:Remove()
	end
end

function draw.RotatedBox( x, y, w, h, ang, color )
	draw.NoTexture()
	surface.SetDrawColor( color or color_white )
	surface.DrawTexturedRectRotated( x, y, w, h, ang )
end

function PANEL:PaintOver(w, h)
	if self.loading then
		surface.SetDrawColor(0, 0, 0)
		surface.DrawRect(0, 0, w, h)

		draw.SimpleText("Loading", "DermaLarge", w/2, h/2 - 40, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		surface.SetMaterial(self.loadingMat)
		surface.SetDrawColor(255, 255, 255)
		surface.DrawTexturedRectRotated(w/2, h/2, 30, 30, 360 - (CurTime()*100)%360)
	end
end

function PANEL:ShowMessage(index, text, subject, sender, time, isCombine)
	self.msgDisp:Clear()

	self.displayIndex = index
	local msgTable = self.inbox[self.displayIndex]

	local header = self.msgDisp:Add("DPanel")
	header:SetBackgroundColor(Color(180, 180, 180))
	header:Dock(TOP)
	header:DockPadding(7, 7, 7, 0)
	header.Paint = function(panel, w, h)
		surface.SetDrawColor(180, 180, 180)
		surface.DrawRect(0, 0, w, h)

		draw.SimpleText("m", "ixPRIconsBig", w - 5, h/2 - 2, Color(176, 124, 32), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		--surface.SetDrawColor(color_black)
		--surface.DrawOutlinedRect(0, 1, w - 1, h - 2, 2)
	end

	local senderBar = header:Add("Panel")
	senderBar:Dock(TOP)
	senderBar:DockMargin(0, 0, 0, 2)
	
	local senderLbl = senderBar:Add("DLabel")
	senderLbl:Dock(LEFT)

	if self.showingInbox then
		senderLbl:SetText("Sender: ")
	else
		senderLbl:SetText("Recipient: ")
	end
	senderLbl:SetTextColor(color_black)
	senderLbl:SetContentAlignment(4)
	senderLbl:SetFont("DermaDefaultBold")
	senderLbl:SizeToContents()

	

	local senderName = senderBar:Add("DLabel")
	senderName:Dock(LEFT)
	if msgTable.alias and !isCombine then
		senderName:SetText(string.format("%s (%s)", msgTable.alias, sender))
	else
		senderName:SetText(sender)
	end
	senderName:SizeToContents()
	senderName:SetTextColor(color_black)
	senderName:SetContentAlignment(4)
	senderBar:SetTall(senderLbl:GetTall())


	if isCombine then

		local cmbLogo = senderBar:Add("DLabel")
		cmbLogo:Dock(LEFT)
		cmbLogo:SetTextColor(color_black)
		cmbLogo:SetText("m")
		cmbLogo:SetFont("ixPRIconsSmall")
		cmbLogo:SetContentAlignment(4)
		cmbLogo:SizeToContents()
		cmbLogo:DockMargin(2, 0, 0, 1)


		--cmbLogo:SetTooltipPanel(toolText)
		cmbLogo:SetHelixTooltip(function(tool)
			local text = tool:AddRow("text")
			text:SetFont("DermaDefault")
			text:SetBackgroundColor(Color(170, 170, 170))
			text:SetText("This message is a Combine official.")
			text:SizeToContents()
			text:SetTextColor(color_black)
			tool.PaintOver = function(panel, w, h)
				surface.SetDrawColor(135, 135, 135)
				surface.DrawOutlinedRect(0, 0, w*panel.fraction, h, 1)
			end
		end)
		

	end
	

	local subjectBar = header:Add("Panel")
	subjectBar:Dock(TOP)
	subjectBar:DockMargin(0, 0, 0, 2)

	local subjectLbl = subjectBar:Add("DLabel")
	subjectLbl:Dock(LEFT)
	subjectLbl:SetText("Subject: ")
	subjectLbl:SetTextColor(color_black)
	subjectLbl:SetContentAlignment(4)
	subjectLbl:SetFont("DermaDefaultBold")
	subjectLbl:SizeToContents()

	local subjectName = subjectBar:Add("DLabel")
	subjectName:Dock(LEFT)
	subjectName:SetText(subject)
	subjectName:SizeToContents()
	subjectName:SetTextColor(color_black)
	subjectName:SetContentAlignment(4)

	local sentBar = header:Add("Panel")
	sentBar:Dock(TOP)

	local sentLbl = sentBar:Add("DLabel")
	sentLbl:Dock(LEFT)
	sentLbl:SetText("Sent: ")
	sentLbl:SetTextColor(color_black)
	sentLbl:SetContentAlignment(4)
	sentLbl:SetFont("DermaDefaultBold")
	sentLbl:SizeToContents()

	

	local timeStr = self:GetTimeString(time)

	local sentNum = sentBar:Add("DLabel")
	sentNum:Dock(LEFT)
	sentNum:SetText(timeStr)
	sentNum:SizeToContents()
	sentNum:SetTextColor(color_black)
	sentNum:SetContentAlignment(4)

	sentBar:SetTall(sentLbl:GetTall())

	header:SetTall(senderBar:GetTall() + subjectBar:GetTall() + sentBar:GetTall() + 4 + 14 + 4)

	local msgLines = ix.util.WrapText(text, 494, "DermaDefault")
	local content = self.msgDisp:Add("DScrollPanel")
	content:Dock(FILL)
	content:GetCanvas():DockPadding(5, 3, 3, 3)
	content.Paint = function(panel, w, h)
		surface.SetDrawColor(color_white)
		surface.DrawRect(0, 0, w, h)
	end

	local contentLbl = content:Add("DLabel")
	contentLbl:Dock(FILL)
	contentLbl:SetText("")

	for k, v in ipairs(msgLines) do
		print("loop")
		contentLbl:SetText(contentLbl:GetText()..v)

		if k != #msgLines then
			contentLbl:SetText(contentLbl:GetText().."\n")
		end
	end

	content:DockMargin(7, 0, 7, 7)

	contentLbl:SetTextColor(color_black)
	contentLbl:SetTall(15*#msgLines)
	contentLbl:SetContentAlignment(7)

	if self.showingInbox then

		local bottomBar = self.msgDisp:Add("Panel")
		bottomBar:Dock(BOTTOM)
		bottomBar:SetTall(28)
		bottomBar:DockPadding(3, 3, 3, 3)

		local delBtn = bottomBar:Add("DButton")
		delBtn:SetSize(50, 12)
		delBtn:Dock(RIGHT)
		delBtn:SetText("Delete")
		delBtn:SetTextColor(color_black)
		delBtn.DoClick = function(panel)
			local popup = self:Add("DFrame")
			popup:SetSize(400, 78)

			popup:SetPos(self:GetWide()/2 - popup:GetWide()/2, self:GetTall()/2 - popup:GetTall()/2)

			popup:SetTitle("Delete Message")
			popup:SetSkin("icterminal")
			popup:ShowCloseButton(false)

			local label = popup:Add("DLabel")
			label:Dock(TOP)
			label:SetContentAlignment(5)
			label:SetText("Are you sure you want to delete this message?")
			label:SetTextColor(color_black)
			label:DockMargin(0, -2, 0, 0)

			local bgColor = Color(12, 201, 250)	

			local bBar = popup:Add("Panel")
			bBar:Dock(BOTTOM)
			bBar:SetTall(18)
			bBar:DockMargin(0, 0, 0, 2)

			local bLeft = bBar:Add("Panel")
			bLeft:SetWide(popup:GetWide()/2 - 3*2)
			local bRight = bBar:Add("Panel")
			bLeft:Dock(LEFT)
			bRight:Dock(RIGHT)
			bRight:SetWide(bLeft:GetWide())

			local cBtn = bRight:Add("DButton")
			cBtn:Dock(LEFT)
			cBtn:SetText("Cancel")
			cBtn:SetTextColor(color_black)
			cBtn.DoClick = function(panel)
				popup:Remove()
			end

			local sBtn = bLeft:Add("DButton")
			sBtn:SetText("Submit")
			sBtn:Dock(RIGHT)
			sBtn:SetTextColor(color_black)
			sBtn.DoClick = function(panel)
				self.msgButtons[self.displayIndex]:Remove()
				print(#self.msgList:GetCanvas():GetChildren()*self.msgList:GetCanvas():GetChildren()[1]:GetTall())
				if #self.msgList:GetCanvas():GetChildren()*self.msgList:GetCanvas():GetChildren()[1]:GetTall() <= 500 - 28 - 24 then 
					self.msgList:GetCanvas():DockPadding(0, 0, 15, 0)
				end
				self.msgButtons[self.displayIndex] = "REMOVED"

				net.Start("prMessengerAction")
					net.WriteUInt(MSG_DELETE, 32)
					net.WriteInt(self.displayIndex, 32)
				net.SendToServer()

				self:ClearMessage()
				popup:Remove()
			end

			
		end
		delBtn.Paint = self.buttonSkin

		local repBtn = bottomBar:Add("DButton")
		repBtn:SetSize(50, 12)
		repBtn:Dock(RIGHT)
		repBtn:SetText("Reply")
		repBtn:SetTextColor(color_black)
		repBtn:DockMargin(0, 0, 3, 0)
		repBtn.Paint = self.buttonSkin
		repBtn.DoClick = function(panel)
			local curMsg = self.inbox[self.displayIndex]

			local subj = (string.sub(curMsg.subject, 1, 3) == "Re:" and curMsg.subject) or "Re: "..curMsg.subject
			local sender
			-- CCA.C17-UNION.i5.19493
			-- OTA.C17-ECHO:OHZ.19493

			if string.find(curMsg.sender, "%u%u%u.C%d%d-%w+.%w+.%d%d%d%d%d", 1, false) or string.find(curMsg.sender, "OTA.%u%d%d-%w+:%u%u%u.%d%d%d%d%d", 1, false) then
				sender = string.sub(curMsg.sender, #curMsg.sender - 4, #curMsg.sender)
			else
				sender = curMsg.sender
			end
			self:WriteMessage(subj, sender)
		end 
	end

	header:SetTall(senderBar:GetTall() + subjectBar:GetTall() + sentBar:GetTall() + 7 * 3 - 1)
	
	
end

function PANEL:LoadMessages(messages)
	self.inbox = messages
	self.numMessages = #messages
	self.msgButtons = {}
	for i = #messages, 1, -1 do
		local v = messages[i]
		local k = i
		local msgButton = self.msgList:Add("DButton")
		msgButton:Dock(TOP)
		msgButton:SetTall(55)
		msgButton:SetText("")
		msgButton:DockPadding(5, 5, 5, 5)
		msgButton.read = v.read
		msgButton.index = k
		msgButton.Paint = function(panel, w, h)
			surface.SetDrawColor(37, 54, 33)
			surface.DrawRect(0, 0, w, h)
			
			if panel:IsHovered() then
				surface.SetDrawColor(0, 0, 0, 50)
				surface.DrawRect(0, 0, w, h)
			end

			if panel:IsDown() then
				surface.SetDrawColor(0, 0, 0, 50)
				surface.DrawRect(0, 0, w, h)
			end

			surface.SetDrawColor(color_black)
			surface.DrawLine(0, h-1, w, h-1)
			
			
		end
		msgButton.PaintOver = function(panel, w, h)
			if !panel.read then
				draw.RoundedBox(3, 5, h - 11, 6, 6, Color(255, 136, 0))
			end
		end

		msgButton.DoClick = function(panel)
			local msgTbl = self.inbox[panel.index]
			self:ShowMessage(panel.index, msgTbl.text, msgTbl.subject, msgTbl.sender, msgTbl.time, msgTbl.isCombine)

			if !panel.read then
				net.Start("prMessengerAction")
					net.WriteUInt(MSG_SETREAD, 32)
					net.WriteInt(panel.index, 32)
				net.SendToServer()
			end

			panel.read = true
		end

		local senderLbl = msgButton:Add("DLabel")
		senderLbl:Dock(TOP)
		senderLbl:SetText(v.alias or v.sender)
		senderLbl:SizeToContents()
		
		local subjectLbl = msgButton:Add("DLabel")
		subjectLbl:Dock(TOP)
		subjectLbl:SetFont("DermaDefaultBold")
		subjectLbl:SetText(v.subject)
		subjectLbl:SizeToContents()

		local dateLbl = msgButton:Add("DLabel")
		dateLbl:Dock(BOTTOM)
		dateLbl:SetContentAlignment(6)
		dateLbl:SetTall(13)
		dateLbl:SetText(self:GetTimeString(v.time))

		self.msgList:AddItem(msgButton)

		self.msgButtons[k] = msgButton
	end

	if #self.msgList:GetCanvas():GetChildren() > 0 and #self.msgList:GetCanvas():GetChildren()*self.msgList:GetCanvas():GetChildren()[1]:GetTall() <= 500 - 28 - 24 then 
		self.msgList:GetCanvas():DockPadding(0, 0, 15, 0)
	end
end

function PANEL:WriteMessage(subject, recipient)
	self.msgDisp:Clear()

	self.displayIndex = nil

	local header = self.msgDisp:Add("DPanel")
	header:SetBackgroundColor(Color(180, 180, 180))
	header:Dock(TOP)
	header:SetTall(18*2 + 7*3)
	header:DockPadding(7, 7, 7, 7)
	header.Paint = function(panel, w, h)
		surface.SetDrawColor(180, 180, 180)
		surface.DrawRect(0, 0, w, h)

		--draw.SimpleText("y", "ixPRIconsBig", w - 5, h/2 - 4, Color(176, 124, 32), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	end

	local bgColor = Color(12, 201, 250)	

	local recipBar = header:Add("Panel")
	recipBar:Dock(TOP)
	recipBar:SetTall(18)
	recipBar:DockMargin(0, 0, 0, 7)

	local recipLbl = recipBar:Add("DLabel")
	recipLbl:Dock(LEFT)
	recipLbl:SetTextColor(color_black)
	recipLbl:SetText("Recipient")
	recipLbl:SetFont("DermaDefaultBold")
	recipLbl:SetContentAlignment(4)
	recipLbl:SizeToContents()
	recipLbl:DockMargin(0, 0, 7, 0)
	
	local recipEntry = recipBar:Add("DTextEntry")
	recipEntry:Dock(FILL)

	recipEntry.Paint = function(panel, w, h)
		surface.SetDrawColor(color_white)
		surface.DrawRect(0, 0, w, h)

		surface.SetDrawColor(color_black)
		surface.DrawOutlinedRect(0, 0, w, h, 1)

		panel:DrawTextEntryText(color_black, bgColor, color_black)
		
	end

	local subjectBar = header:Add("Panel")
	subjectBar:Dock(TOP)
	subjectBar:SetTall(18)

	local subjectLbl = subjectBar:Add("DLabel")
	subjectLbl:Dock(LEFT)
	subjectLbl:SetTextColor(color_black)
	subjectLbl:SetText("Subject")
	subjectLbl:SetFont("DermaDefaultBold")
	subjectLbl:SetContentAlignment(4)
	subjectLbl:SizeToContents()
	subjectLbl:DockMargin(0, 0, 7, 0)
	
	local subjectEntry = subjectBar:Add("DTextEntry")
	subjectEntry:Dock(FILL)

	subjectEntry.Paint = function(panel, w, h)
		surface.SetDrawColor(color_white)
		surface.DrawRect(0, 0, w, h)

		surface.SetDrawColor(color_black)
		surface.DrawOutlinedRect(0, 0, w, h, 1)

		panel:DrawTextEntryText(color_black, bgColor, color_black)
		
	end
	
	local msgEntry = self.msgDisp:Add("DTextEntry")
	msgEntry:Dock(FILL)
	msgEntry:SetMultiline(true)

	msgEntry.Paint = function(panel, w, h)
		surface.SetDrawColor(color_white)
		surface.DrawRect(0, 0, w, h)

		panel:DrawTextEntryText(color_black, bgColor, color_black)
	end

	msgEntry.Paint = function(panel, w, h)
		surface.SetDrawColor(color_white)
		surface.DrawRect(0, 0, w, h)

		panel:DrawTextEntryText(color_black, bgColor, color_black)
	end

	msgEntry:DockMargin(7, 0, 7, 0)
	
	local bottomBar = self.msgDisp:Add("Panel")
	bottomBar:Dock(BOTTOM)
	bottomBar:SetTall(28)
	bottomBar:DockPadding(3, 3, 3, 3)
	bottomBar:DockMargin(0, 4, 4, 4)

	local sendBtn = bottomBar:Add("DButton")
	sendBtn:SetSize(50, 12)
	sendBtn:Dock(RIGHT)
	sendBtn:SetText("Send")
	sendBtn:SetTextColor(color_black)
	sendBtn.DoClick = function(panel)
		local msgText = msgEntry:GetValue()
		print("msgText", msgText)
		local recipient = recipEntry:GetValue()
		local subject = subjectEntry:GetValue()

		local textComp = util.Compress(msgText)
		print("comp", textComp, textComp == nil)

		self.pendingsend = {
			text = msgText,
			recipient = recipient,
			subject = subject
		}

		net.Start("prMessengerAction")
			net.WriteUInt(MSG_SEND, 32)
			net.WriteInt(#textComp, 32)
			net.WriteData(textComp)

			net.WriteString(subject)
			net.WriteString(recipient)
		net.SendToServer()
	end

	sendBtn.Paint = self.buttonSkin

	if recipient then recipEntry:SetValue(recipient) end
	if subject then subjectEntry:SetValue(subject) end
end

function PANEL:ClearMessage()
	self.msgDisp:Clear()
end

function PANEL:GetTimeString(time)
	local timeDist = os.time() - time
	local timeStr

	if timeDist >= 60*60*24*365 then
		local num = math.abs(tonumber(os.date("%Y", time) - tonumber(os.date("%Y"))))

		if num > 1 then
			timeStr = num.." Years Ago"
		else
			timeStr = num.." Year Ago"
		end
	elseif timeDist >= 60*60*24*31 then
		local num = math.abs(tonumber(os.date("%m", time) - tonumber(os.date("%m"))))

		if num > 1 then
			timeStr = num.." Months Ago"
		else
			timeStr = num.." Month Ago"
		end
	elseif timeDist >= 60*60*24*7 then
		local num = math.abs(tonumber(os.date("%W", time) - tonumber(os.date("%W"))))

		if num  > 1 then
			timeStr = num.." Weeks Ago"
		else
			timeStr = num.." Week Ago"
		end
	elseif timeDist >= 60*60*24 then
		local num = math.abs(tonumber(os.date("%j", time) - tonumber(os.date("%j"))))

		if num  > 1 then
			timeStr = num.." Days Ago"
		else
			timeStr = num.." Day Ago"
		end
	elseif timeDist >= 60*60 then
		local num = math.abs(tonumber(os.date("%H", time) - tonumber(os.date("%H"))))

		if num  > 1 then
			timeStr = num.." Hours Ago"
		else
			timeStr = num.." Hour Ago"
		end
	elseif timeDist >= 60 then
		local num = math.abs(tonumber(os.date("%M", time) - tonumber(os.date("%M"))))

		if num  > 1 then
			timeStr = num.." Minutes Ago"
		else
			timeStr = num.." Minute Ago"
		end
	else
		local num = math.abs(tonumber(os.date("%S", time) - tonumber(os.date("%S"))))

		if num  > 1 then
			timeStr = num.." Seconds Ago"
		else
			timeStr = num.." Second Ago"
		end
	end

	return timeStr
end

function PANEL:ShowInbox()
	self.msgList:Clear()
	self.showingInbox = true
	self.msgList:GetCanvas():DockPadding(0, 0, 0, 0)

	local msgTall = 55	

	for i = #self.inbox, 1, -1 do
		local v = self.inbox[i]
		local k = i
		if self.msgButtons[k] == "REMOVED" then continue end
		local msgButton = self.msgList:Add("DButton")
		msgButton:Dock(TOP)
		msgButton:SetTall(55)
		msgButton:SetText("")
		msgButton:DockPadding(5, 5, 5, 5)
		msgButton.read = v.read
		msgButton.index = k
		msgButton.Paint = function(panel, w, h)
			surface.SetDrawColor(37, 54, 33)
			surface.DrawRect(0, 0, w, h)
			
			if panel:IsHovered() then
				surface.SetDrawColor(0, 0, 0, 50)
				surface.DrawRect(0, 0, w, h)
			end

			if panel:IsDown() then
				surface.SetDrawColor(0, 0, 0, 50)
				surface.DrawRect(0, 0, w, h)
			end

			surface.SetDrawColor(color_black)
			surface.DrawLine(0, h-1, w, h-1)
			
			
		end
		msgButton.PaintOver = function(panel, w, h)
			if !panel.read then
				draw.RoundedBox(3, 5, h - 11, 6, 6, Color(255, 136, 0))
			end
		end

		msgButton.DoClick = function(panel)
			local msgTbl = self.inbox[panel.index]
			self:ShowMessage(panel.index, msgTbl.text, msgTbl.subject, msgTbl.sender, msgTbl.time, msgTbl.isCombine)

			if !panel.read then
				net.Start("prMessengerAction")
					net.WriteUInt(MSG_SETREAD, 32)
					net.WriteInt(panel.index, 32)
				net.SendToServer()
			end

			panel.read = true
		end

		local senderLbl = msgButton:Add("DLabel")
		senderLbl:Dock(TOP)
		senderLbl:SetText(v.alias or v.sender)
		senderLbl:SizeToContents()
		
		local subjectLbl = msgButton:Add("DLabel")
		subjectLbl:Dock(TOP)
		subjectLbl:SetFont("DermaDefaultBold")
		subjectLbl:SetText(v.subject)
		subjectLbl:SizeToContents()

		local dateLbl = msgButton:Add("DLabel")
		dateLbl:Dock(BOTTOM)
		dateLbl:SetContentAlignment(6)
		dateLbl:SetTall(13)
		dateLbl:SetText(self:GetTimeString(v.time))

		self.msgList:AddItem(msgButton)
		self.msgButtons[k] = msgButton
	end

	if #self.inbox*msgTall <= 500 - 28 - 24 then 
		self.msgList:GetCanvas():DockPadding(0, 0, 15, 0)
	end
end

function PANEL:ShowOutbox()
	self.msgList:Clear()
	self.showingInbox = false

	local msgTall = 55
	
	for i = #self.outbox, 1, -1 do
		local v = self.outbox[i]
		local k = i
		local msgButton = self.msgList:Add("DButton")
		msgButton:Dock(TOP)
		msgButton:SetTall(55)
		msgButton:SetText("")
		msgButton:DockPadding(5, 5, 5, 5)
		msgButton.index = k
		msgButton.Paint = function(panel, w, h)
			surface.SetDrawColor(37, 54, 33)
			surface.DrawRect(0, 0, w, h)
			
			if panel:IsHovered() then
				surface.SetDrawColor(0, 0, 0, 50)
				surface.DrawRect(0, 0, w, h)
			end

			if panel:IsDown() then
				surface.SetDrawColor(0, 0, 0, 50)
				surface.DrawRect(0, 0, w, h)
			end

			surface.SetDrawColor(color_black)
			surface.DrawLine(0, h-1, w, h-1)
			
			
		end

		msgButton.DoClick = function(panel)
			local msgTbl = self.outbox[panel.index]
			self:ShowMessage(panel.index, msgTbl.text, msgTbl.subject, msgTbl.recipient, msgTbl.time, msgTbl.isCombine)
		end
	
		local senderLbl = msgButton:Add("DLabel")
		senderLbl:Dock(TOP)
		senderLbl:SetText(v.alias or v.recipient)
		senderLbl:SizeToContents()
		
		local subjectLbl = msgButton:Add("DLabel")
		subjectLbl:Dock(TOP)
		subjectLbl:SetFont("DermaDefaultBold")
		subjectLbl:SetText(v.subject)
		subjectLbl:SizeToContents()

		local dateLbl = msgButton:Add("DLabel")
		dateLbl:Dock(BOTTOM)
		dateLbl:SetContentAlignment(6)
		dateLbl:SetTall(13)
		dateLbl:SetText(self:GetTimeString(v.time))

		self.msgList:AddItem(msgButton)
	end

	if #self.outbox*msgTall <= 500 - 28 - 24 then 
		self.msgList:GetCanvas():DockPadding(0, 0, 15, 0)
	end
end

function PANEL:LoginAs(id)
	-- to be implemented: logging into an organization's mailbox or
	-- somebody else's mailbox
end

function PANEL:Logout()
	self:GetParent():Remove()
end

vgui.Register("ixMessenger", PANEL, "EditablePanel")

PANEL = {}

function PANEL:Init()
	self.baseW = 700
	self.baseH = 500
	self:DockPadding(5, 5, 5, 5)
	local bigHead = self:Add("DLabel")
	bigHead:Dock(TOP)
	bigHead:SetFont("DermaLarge")
	bigHead:SetText("Organization Manager")
	bigHead:SizeToContents()
	bigHead:SetTextColor(color_black)
	local smallHead = self:Add("DLabel")
	smallHead:Dock(TOP)
	smallHead:SetText("ORGMNG 17")
	smallHead:SizeToContents()
	smallHead:DockMargin(0, 4, 0, 0)
	smallHead:SetTextColor(color_black)
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(185, 185, 185)
	surface.DrawRect(0, 0, w, h)
end

vgui.Register("ixOrgManager", PANEL, "EditablePanel")

PANEL = {}

function PANEL:Init()
	self:ShowMainMenu()
end

function PANEL:ShowMainMenu()
	self:DockPadding(5, 5, 5, 5)
	self:SetBaseSize(700, 500)

	local leftBar = self:Add("Panel")
	leftBar:Dock(LEFT)
	leftBar:SetWide(300)

	local bigHead = leftBar:Add("DLabel")
	bigHead:Dock(TOP)
	bigHead:SetFont("DermaLarge")
	bigHead:SetText("Business Access Node")
	bigHead:SizeToContents()
	bigHead:SetTextColor(color_white)
	local smallHead = leftBar:Add("DLabel")
	smallHead:Dock(TOP)
	smallHead:SetText("ACCNODE")
	smallHead:SizeToContents()
	smallHead:DockMargin(0, 4, 0, 0)
	smallHead:SetTextColor(color_white)

	local fields = leftBar:Add("Panel")
	fields:SetTall(200)
	fields:Dock(TOP)
	fields:DockMargin(0, 20, 0, 0)

	local bizName = fields:Add("Panel")
	bizName:Dock(TOP)
	bizName:SetTall(18)

	local nameLbl = bizName:Add("DLabel")
	nameLbl:SetTextColor(color_white)
	nameLbl:Dock(LEFT)
	nameLbl:SetContentAlignment(4)
	nameLbl:SetText("Business Name")
	nameLbl:SetFont("DermaDefaultBold")
	nameLbl:SizeToContents()
	
	local nameVal = bizName:Add("DLabelEditable")
	nameVal:Dock(FILL)
	nameVal:SetContentAlignment(6)
	nameVal:SetText("Grizzly Grotto")
	nameVal:SizeToContents()
	nameVal:SetTextColor(color_white)

	local bizOwner = fields:Add("Panel")
	bizOwner:Dock(TOP)
	bizOwner:SetTall(18)

	local ownerLbl = bizOwner:Add("DLabel")
	ownerLbl:SetTextColor(color_white)
	ownerLbl:Dock(LEFT)
	ownerLbl:SetContentAlignment(4)
	ownerLbl:SetText("Owner")
	ownerLbl:SetFont("DermaDefaultBold")
	ownerLbl:SizeToContents()
	
	local ownerVal = bizOwner:Add("DLabel")
	ownerVal:Dock(FILL)
	ownerVal:SetContentAlignment(6)
	ownerVal:SetText("Lou Tenant (92077)")
	ownerVal:SizeToContents()
	ownerVal:SetTextColor(color_white)

	local bizEmps = fields:Add("Panel")
	bizEmps:Dock(TOP)
	bizEmps:SetTall(18)

	local ownerLbl = bizEmps:Add("DLabel")
	ownerLbl:SetTextColor(color_white)
	ownerLbl:Dock(LEFT)
	ownerLbl:SetContentAlignment(4)
	ownerLbl:SetText("Number of Employees")
	ownerLbl:SetFont("DermaDefaultBold")
	ownerLbl:SizeToContents()
	
	local ownerVal = bizEmps:Add("DLabel")
	ownerVal:Dock(FILL)
	ownerVal:SetContentAlignment(6)
	ownerVal:SetText("3")
	ownerVal:SizeToContents()
	ownerVal:SetTextColor(color_white)

	local bizMsgID = fields:Add("Panel")
	bizMsgID:Dock(TOP)
	bizMsgID:SetTall(18)

	local msgidLbl = bizMsgID:Add("DLabel")
	msgidLbl:SetTextColor(color_white)
	msgidLbl:Dock(LEFT)
	msgidLbl:SetContentAlignment(4)
	msgidLbl:SetText("Messenger ID")
	msgidLbl:SetFont("DermaDefaultBold")
	msgidLbl:SizeToContents()
	
	local msgidVal = bizMsgID:Add("DLabel")
	msgidVal:Dock(FILL)
	msgidVal:SetContentAlignment(6)
	msgidVal:SetText("A1B2C3")
	msgidVal:SizeToContents()
	msgidVal:SetTextColor(color_white)

	local msgidLock = bizMsgID:Add("DLabel")
	msgidLock:Dock(RIGHT)
	msgidLock:DockMargin(4, 0, 0, 0)
	msgidLock:SetContentAlignment(6)
	msgidLock:SetText("P")
	msgidLock:SetFont("ixIconsSmall")
	msgidLock:SizeToContents()
	msgidLock:SetTextColor(color_white)

	local bizPos = fields:Add("Panel")
	bizPos:Dock(TOP)
	bizPos:SetTall(18)

	local posLbl = bizPos:Add("DLabel")
	posLbl:SetTextColor(color_white)
	posLbl:Dock(LEFT)
	posLbl:SetContentAlignment(4)
	posLbl:SetText("Your Position")
	posLbl:SetFont("DermaDefaultBold")
	posLbl:SizeToContents()
	
	local posVal = bizPos:Add("DLabel")
	posVal:Dock(FILL)
	posVal:SetContentAlignment(6)
	posVal:SetText("Owner")
	posVal:SizeToContents()
	posVal:SetTextColor(color_white)

	fields:SetTall(#fields:GetChildren()*fields:GetChildren()[1]:GetTall())

	local buttons = leftBar:Add("Panel")
	buttons:Dock(TOP)
	buttons:DockMargin(0, 20, 0, 0)
	
	local clockBtn = buttons:Add("DButton")
	clockBtn:Dock(TOP)
	clockBtn:SetTall(24)
	clockBtn:SetText("Timeclock")
	clockBtn:DockMargin(0, 0, 0, 7)
	clockBtn.DoClick = function()
		self:Clear()
		self:DockPadding(0, 0, 0, 0)
		local timeClock = self:ShowWindow("CWUTimeclock")
		timeClock.Logout = function(panel)
			self:Clear()
			self:DockPadding(0, 0, 0, 0)
			self:ShowMainMenu()
		end
		timeClock:Dock(FILL)
	end

	local msgBtn = buttons:Add("DButton")
	msgBtn:Dock(TOP)
	msgBtn:SetTall(24)
	msgBtn:SetText("Messenger")
	msgBtn:DockMargin(0, 0, 0, 7)
	msgBtn.DoClick = function()
		self:Clear()
		self:DockPadding(0, 0, 0, 0)
		local msg = self:Add("ixMessenger")
		msg.Logout = function(panel)
			self:Clear()
			self:DockPadding(0, 0, 0, 0)
			self:ShowMainMenu()
		end
		msg:LoginAs("A1B2C3")
		msg:Dock(FILL)
	end

	local suppsBtn = buttons:Add("DButton")
	suppsBtn:Dock(TOP)
	suppsBtn:SetTall(24)
	suppsBtn:SetText("Order Supplies")
	suppsBtn:DockMargin(0, 0, 0, 7)

	local empsBtn = buttons:Add("DButton")
	empsBtn:Dock(TOP)
	empsBtn:SetTall(24)
	empsBtn:SetText("Manage Employees")

	buttons:SetTall(#buttons:GetChildren()*(buttons:GetChildren()[1]:GetTall() + 7) - 7)

	local rightBar = self:Add("Panel")
	rightBar:Dock(FILL)
	rightBar:DockMargin(10, 69, 0, 0)

	local rentAmtBar = rightBar:Add("Panel")
	rentAmtBar:Dock(TOP)
	rentAmtBar:SetTall(18)

	local rentAmtVal = rentAmtBar:Add("DLabel")
	rentAmtVal:SetTextColor(color_white)
	rentAmtVal:Dock(LEFT)
	rentAmtVal:SetContentAlignment(4)
	rentAmtVal:SetText("Rent Amount")
	rentAmtVal:SetFont("DermaDefaultBold")
	rentAmtVal:SizeToContents()
	
	local rentAmtVal = rentAmtBar:Add("DLabelEditable")
	rentAmtVal:Dock(FILL)
	rentAmtVal:SetContentAlignment(6)
	rentAmtVal:SetText("10 Tokens")
	rentAmtVal:SizeToContents()
	rentAmtVal:SetTextColor(color_white)

	local dueBar = rightBar:Add("Panel")
	dueBar:Dock(TOP)
	dueBar:SetTall(18)

	local dueBarVal = dueBar:Add("DLabel")
	dueBarVal:SetTextColor(color_white)
	dueBarVal:Dock(LEFT)
	dueBarVal:SetContentAlignment(4)
	dueBarVal:SetText("Next Payment Due")
	dueBarVal:SetFont("DermaDefaultBold")
	dueBarVal:SizeToContents()
	
	local dueBarLbl = dueBar:Add("DLabelEditable")
	dueBarLbl:Dock(FILL)
	dueBarLbl:SetContentAlignment(6)
	dueBarLbl:SetText("2 Days")
	dueBarLbl:SizeToContents()
	dueBarLbl:SetTextColor(color_white)

	local balBar = rightBar:Add("Panel")
	balBar:Dock(TOP)
	balBar:SetTall(18)
	balBar:DockMargin(0, 0, 0, 5)

	local balBarVal = balBar:Add("DLabel")
	balBarVal:SetTextColor(color_white)
	balBarVal:Dock(LEFT)
	balBarVal:SetContentAlignment(4)
	balBarVal:SetText("Overdue Balance")
	balBarVal:SetFont("DermaDefaultBold")
	balBarVal:SizeToContents()
	
	local balBarLbl = balBar:Add("DLabelEditable")
	balBarLbl:Dock(FILL)
	balBarLbl:SetContentAlignment(6)
	balBarLbl:SetText("0 Tokens")
	balBarLbl:SizeToContents()
	balBarLbl:SetTextColor(color_white)

	local payBtn = rightBar:Add("DButton")
	payBtn:Dock(TOP)
	payBtn:SetTall(24)
	payBtn:SetText("Make Payment")
	payBtn:DockMargin(0, 0, 0, 10)
	payBtn.DoClick = function()
		self:Clear()
		self:DockPadding(0, 0, 0, 0)
		local msg = self:Add("ixPaymentClient")
		msg.Logout = function(panel)
			self:Clear()
			self:DockPadding(0, 0, 0, 0)
			self:ShowMainMenu()
		end
		msg:Dock(FILL)
	end

	local lastChk = rightBar:Add("Panel")
	lastChk:Dock(TOP)
	lastChk:SetTall(18)

	local lastChkVal = lastChk:Add("DLabel")
	lastChkVal:SetTextColor(color_white)
	lastChkVal:Dock(LEFT)
	lastChkVal:SetContentAlignment(4)
	lastChkVal:SetText("Last Check-In")
	lastChkVal:SetFont("DermaDefaultBold")
	lastChkVal:SizeToContents()
	
	local lastChkLbl = lastChk:Add("DLabelEditable")
	lastChkLbl:Dock(FILL)
	lastChkLbl:SetContentAlignment(6)
	lastChkLbl:SetText("Today")
	lastChkLbl:SizeToContents()
	lastChkLbl:SetTextColor(color_white)

	local nextChk = rightBar:Add("Panel")
	nextChk:Dock(TOP)
	nextChk:SetTall(18)

	local nextChkVal = nextChk:Add("DLabel")
	nextChkVal:SetTextColor(color_white)
	nextChkVal:Dock(LEFT)
	nextChkVal:SetContentAlignment(4)
	nextChkVal:SetText("Next Required Check-In")
	nextChkVal:SetFont("DermaDefaultBold")
	nextChkVal:SizeToContents()
	
	local nextChkLbl = nextChk:Add("DLabelEditable")
	nextChkLbl:Dock(FILL)
	nextChkLbl:SetContentAlignment(6)
	nextChkLbl:SetText("3 Days")
	nextChkLbl:SizeToContents()
	nextChkLbl:SetTextColor(color_white)
	
	


	-- timeclock
	-- messenger
	-- order supplies
	-- employee manager
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(37, 88, 120)
	surface.DrawRect(0, 0, w, h)

	local polyPoints = {
		{x = 45, y = 15},
		{x = 45, y = 25},
		{x = w - 35, y = 25},
		{x = w - 35, y = 15},
		{x = w - 15, y = 50},
		{x = w - 15, y = h - 50},
		{x = w - 70, y = h - 15},
		{x = w - 90, y = h - 15},
		{x = w - 90, y = h - 25},
		{x = 75, y = h - 25},
		{x = 75, y = h - 15},
		{x = 55, y = h - 15},
		{x = 15, y = h - 35},
		{x = 15, y = 35},
		
	}

	if self.locked then
		surface.SetDrawColor(9, 22, 39)
		draw.NoTexture()
		surface.DrawPoly(polyPoints)

		draw.SimpleText("Failure to Authenticate", "DermaLarge", w*0.125, w*0.167 - 12, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText("You are not authorized to access this terminal.", "DermaDefault", w*0.125, w*0.167 + 12, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)


		draw.SimpleText("ACCESS POINT P21 C17", "DermaDefault", 5, h - 5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
	else
		surface.SetDrawColor(14, 58, 84)
		surface.DrawRect(309, 0, w, h)
		
		draw.SimpleText("m", "ixPRIconsBig", w - 5, h - 5, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
	end
end

function PANEL:SetBaseSize(w, h)
	self.baseW = w
	self.baseH = h
	self:SetSize(w, h)
	self:Center()
end


vgui.Register("ixStoreManager", PANEL, "EditablePanel")

PANEL = {}

function PANEL:Init()
	local topBar = self:Add("Panel")
	topBar:Dock(TOP)
	topBar:SetTall(64)

	self:SetWide(700)
	topBar.Paint = function(panel, w, h)
		surface.SetDrawColor(45, 46, 75)
		surface.DrawRect(0, 0, w, H)
	end
	local topLbl = topBar:Add("DLabel")
	topLbl:SetText("Ministry of City Management")
	topLbl:Dock(TOP)
	topLbl:SetTall(3*topBar:GetTall()/4 - 9)
	topLbl:SetContentAlignment(2)
	topLbl:SetFont("DermaLarge")

	local bottomLbl = topBar:Add("DLabel")
	bottomLbl:SetText("Payment Processor")
	bottomLbl:Dock(FILL)
	bottomLbl:SizeToContents()
	bottomLbl:SetContentAlignment(8)

	local mainPanel = self:Add("Panel")
	mainPanel:Dock(FILL)
	mainPanel:DockPadding(5, 5, 5, 5)

	local citName = mainPanel:Add("DLabel")
	citName:SetText("Dweller, Vault #82077")
	citName:Dock(TOP)
	citName:SizeToContents()
	citName:SetContentAlignment(6)
	citName:SetTextColor(color_black)

	local payingTo = mainPanel:Add("DLabel")
	payingTo:Dock(TOP)
	payingTo:SetTextColor(color_black)
	payingTo:SetText("Paying To")	
	payingTo:SizeToContents()

	self.recipLbl = mainPanel:Add("DLabel")
	self.recipLbl:Dock(TOP)
	self.recipLbl:SetTextColor(color_black)
	self.recipLbl:SetFont("DermaDefaultBold")
	self.recipLbl:SetText("CWU Commerce Corps")
	self.recipLbl:SizeToContents()
	self.recipLbl:DockMargin(0, 0, 0, 10)

	local amtLbl = mainPanel:Add("DLabel")
	amtLbl:Dock(TOP)
	amtLbl:SetTextColor(color_black)
	amtLbl:SetText("Enter Amount")
	amtLbl:SizeToContents()

	self.amtEntry = mainPanel:Add("DTextEntry")
	self.amtEntry:Dock(TOP)
	self.amtEntry:SetTall(amtLbl:GetTall() + 4)
	self.amtEntry:DockMargin(-1, 3, 600, 0)
	self.amtEntry:SetTextColor(color_black)
	self.amtEntry:SetNumeric(true)

	local payBtn = mainPanel:Add("DButton")
	payBtn:SetText("Submit Payment")
	payBtn:SetWide(144)
	payBtn:SetPos(self:GetWide()/2 - payBtn:GetWide()/2, 128)
	payBtn:SetTextColor(color_black)
end

-- this is meant to be overridden
function PANEL:Logout()
	self:Remove()
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(200, 200, 200)
	surface.DrawRect(0, 0, w, h)
end

vgui.Register("ixPaymentClient", PANEL, "EditablePanel")

PANEL = {}

function PANEL:Init()
	self.rationLbl = self:Add("DLabel")
	self.rationLbl:Dock(TOP)
	self.rationLbl:SetText(string.format("Ration Cycles: %s/%s", 0, Schema.RationQuota or 3))
	self.rationLbl:SizeToContents()
	print("TALL", self.rationLbl:GetTall())
	self.rationLbl:SetContentAlignment(5)

	self.workLbl = self:Add("DLabel")
	self.workLbl:Dock(TOP)
	self.workLbl:SetText(string.format("Work Cycles: %s/%s", 0, Schema.WorkCycleQuota or 1))
	self.workLbl:SizeToContents()
	self.workLbl:DockMargin(0, 5, 0, 8)
	self.workLbl:SetContentAlignment(5)

	self.timeVal = self:Add("DLabel")
	self.timeVal:Dock(TOP)
	self.timeVal:SetText("")
	self.timeVal:SizeToContents()
	self.timeVal:DockMargin(0, 5, 0, 0)
	self.timeVal:SetContentAlignment(5)
end 

function PANEL:Think()
	local globalTime = os.time()
	local todayData = os.date("!*t", globalTime + 24*60*60)
	--PrintTable(todayData)
	todayData.hour = !todayData.isdst and 4 or 3
	todayData.min = 0
	todayData.sec = 0
	local midnightTime = os.time(todayData)

	local timeLeft = midnightTime - globalTime
	local timeLeftNice = os.date("%X", timeLeft)
	--print(timeLeft)
	self.timeVal:SetText(timeLeftNice.." until the day ends.")
end

function PANEL:SetValues(numRations, numWork)
	self.rationLbl:SetText(string.format("Ration Cycles: %s/%s", numRations, Schema.RationQuota or 3))
	self.workLbl:SetText(string.format("Work Cycles: %s/%s", numWork, Schema.WorkCycleQuota or 1))
end

vgui.Register("ixViewQuotas", PANEL, "EditablePanel")

concommand.Add("testorg", function()
	local frame = vgui.Create("DFrame")
	frame:MakePopup()
	frame:SetSize(1920, 1080)
	frame:Center()
	frame:SetTitle("Organizations")
	
	local manager = frame:Add("DisplayPanel")
	manager:Center()
	manager:ShowWindow("ixStoreManager")
end)

concommand.Add("testquotas", function()
	local frame = vgui.Create("DFrame")
	frame:MakePopup()
	frame:SetSize(155, 24 + 18*4 + 4*2 - 10)
	frame:Center()
	frame:SetTitle("Quotas")
	
	local quotas = frame:Add("ixViewQuotas")
	quotas:Dock(FILL)
end)

net.Receive("ixViewQuotas", function()
	local numRations = net.ReadInt(32)
	local numWorks = net.ReadInt(32)

	local frame = vgui.Create("DFrame")
	frame:MakePopup()
	frame:SetSize(155, 24 + 18*4 + 4*2 - 10)
	frame:Center()
	frame:SetTitle("Quotas")

	

	local quotas = frame:Add("ixViewQuotas")
	quotas:Dock(FILL)
	quotas:SetValues(numRations, numWorks)
end)