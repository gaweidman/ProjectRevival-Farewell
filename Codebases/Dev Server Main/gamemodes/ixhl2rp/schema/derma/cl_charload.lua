
local errorModel = "models/error.mdl"
local PANEL = {}

AccessorFunc(PANEL, "animationTime", "AnimationTime", FORCE_NUMBER)

local function SetCharacter(self, character)
	self.character = character

	if (character) then
		self:SetModel(character:GetModel(), character:GetData("skin", 0))
		self:SetSkin(character:GetData("skin", 0))

		for i = 0, (self:GetNumBodyGroups() - 1) do
			self:SetBodygroup(i, 0)
		end

		local bodygroups = character:GetData("groups", nil)

		if (istable(bodygroups)) then
			for k, v in pairs(bodygroups) do
				self:SetBodygroup(k, v)
			end
		end
	else
		self:SetModel(errorModel)
	end
end

local function GetCharacter(self)
	return self.character
end

function PANEL:Init()
	self.cards = {}

	self.activeCharacter = ClientsideModel(errorModel)
	self.activeCharacter:SetNoDraw(true)
	self.activeCharacter.SetCharacter = SetCharacter
	self.activeCharacter.GetCharacter = GetCharacter

	self.lastCharacter = ClientsideModel(errorModel)
	self.lastCharacter:SetNoDraw(true)
	self.lastCharacter.SetCharacter = SetCharacter
	self.lastCharacter.GetCharacter = GetCharacter

	self.animationTime = 0.5

	self.shadeY = 0
	self.shadeHeight = 0

	self.cameraPosition = Vector(80, 0, 35)
	self.cameraAngle = Angle(0, 180, 0)
	self.lastPaint = 0
end

function PANEL:AddCard(character)
	local newCard = vgui.Create("ixCharCard", self)
	newCard:AddPanel(newCard)
	newCard.model:SetModel(Model(character:GetModel()), character:GetData("skin", 0))
	newCard:DockMargin(30, 0, 0, 0)

	self.cards[#self.cards + 1] = newCard
end

function PANEL:SetActiveCharacter(character)
	self.shadeY = self:GetTall()
	self.shadeHeight = self:GetTall()

	-- set character immediately if we're an error (something isn't selected yet)
	if (self.activeCharacter:GetModel() == errorModel) then
		self.activeCharacter:SetCharacter(character)
		self:ResetSequence(self.activeCharacter)

		return
	end

	-- if the animation is already playing, we update its parameters so we can avoid restarting
	local shade = self:GetTweenAnimation(1)
	local shadeHide = self:GetTweenAnimation(2)

	if (shade) then
		shade.newCharacter = character
		return
	elseif (shadeHide) then
		shadeHide.queuedCharacter = character
		return
	end

	self.lastCharacter:SetCharacter(self.activeCharacter:GetCharacter())
	self:ResetSequence(self.lastCharacter, self.activeCharacter)

	shade = self:CreateAnimation(self.animationTime * 0.5, {
		index = 1,
		target = {
			shadeY = 0,
			shadeHeight = self:GetTall()
		},
		easing = "linear",

		OnComplete = function(shadeAnimation, shadePanel)
			shadePanel.activeCharacter:SetCharacter(shadeAnimation.newCharacter)
			shadePanel:ResetSequence(shadePanel.activeCharacter)

			shadePanel:CreateAnimation(shadePanel.animationTime, {
				index = 2,
				target = {shadeHeight = 0},
				easing = "outQuint",

				OnComplete = function(animation, panel)
					if (animation.queuedCharacter) then
						panel:SetActiveCharacter(animation.queuedCharacter)
					else
						panel.lastCharacter:SetCharacter(nil)
					end
				end
			})
		end
	})

	shade.newCharacter = character
end

function PANEL:Paint(width, height)
	local x, y = ScrW()/2 - width/2, ScrH()/2 - height/2
	local bTransition = self.lastCharacter:GetModel() != errorModel
	local modelFOV = (ScrW() > ScrH() * 1.8) and 92 or 70

	

	/*

	cam.Start3D(self.cameraPosition, self.cameraAngle, modelFOV, x, y, width, height)
		render.SuppressEngineLighting(true)
		render.SetLightingOrigin(self.activeCharacter:GetPos())

		-- setup lighting
		render.SetModelLighting(0, 1.5, 1.5, 1.5)

		for i = 1, 4 do
			render.SetModelLighting(i, 0.4, 0.4, 0.4)
		end

		render.SetModelLighting(5, 0.04, 0.04, 0.04)

		-- clip anything out of bounds
		local curparent = self
		local rightx = self:GetWide()
		local leftx = 0
		local topy = 0
		local bottomy = self:GetTall()
		local previous = curparent

		while (curparent:GetParent() != nil) do
			local lastX, lastY = previous:GetPos()
			curparent = curparent:GetParent()

			topy = math.Max(lastY, topy + lastY)
			leftx = math.Max(lastX, leftx + lastX)
			bottomy = math.Min(lastY + previous:GetTall(), bottomy + lastY)
			rightx = math.Min(lastX + previous:GetWide(), rightx + lastX)

			previous = curparent
		end

		ix.util.ResetStencilValues()
		render.SetStencilEnable(true)
			render.SetStencilWriteMask(30)
			render.SetStencilTestMask(30)
			render.SetStencilReferenceValue(31)

			render.SetStencilCompareFunction(STENCIL_ALWAYS)
			render.SetStencilPassOperation(STENCIL_REPLACE)
			render.SetStencilFailOperation(STENCIL_KEEP)
			render.SetStencilZFailOperation(STENCIL_KEEP)

			self:LayoutEntity(self.activeCharacter)
				self.activeCharacter:DrawModel()

			render.SetStencilCompareFunction(STENCIL_EQUAL)
			render.SetStencilPassOperation(STENCIL_KEEP)

			cam.Start2D()
				derma.SkinFunc("PaintCharacterTransitionOverlay", self, 0, self.shadeY, width, self.shadeHeight)
			cam.End2D()
		render.SetStencilEnable(false)

		render.SetScissorRect(0, 0, 0, 0, false)
		render.SuppressEngineLighting(false)
	cam.End3D()

	*/

	self.lastPaint = RealTime()
end

function PANEL:OnRemove()
	self.lastCharacter:Remove()
	self.activeCharacter:Remove()
end


vgui.Register("ixCharMenuCarousel", PANEL, "DHorizontalScroller")

-- character load panel
PANEL = {}

AccessorFunc(PANEL, "animationTime", "AnimationTime", FORCE_NUMBER)
AccessorFunc(PANEL, "backgroundFraction", "BackgroundFraction", FORCE_NUMBER)

function PANEL:Init()
	local parent = self:GetParent()
	local padding = self:GetPadding()
	local halfWidth = parent:GetWide() * 0.5 - (padding * 2)
	local halfHeight = parent:GetTall() * 0.5 - (padding * 2)
	local modelFOV = (ScrW() > ScrH() * 1.8) and 102 or 78

	self.animationTime = 0
	self.backgroundFraction = 1

	self:DockPadding(padding, padding, padding, padding)

	-- main panel
	self.panel = self:AddSubpanel("main")
	self.panel:SetTitle("Continue Your Story")
	self.panel.OnSetActive = function()
		self:CreateAnimation(self.animationTime, {
			index = 2,
			target = {backgroundFraction = 1},
			easing = "outQuint",
		})
	end

	local back = self.panel:Add("ixMenuButton")
	back:Dock(BOTTOM)
	back:SetText("return")
	back:SizeToContents()
	back.DoClick = function()
		self:SlideDown()
		parent.mainPanel:Undim()
	end

	self.carousel = self.panel:Add("DHorizontalScroller")
	self.carousel:SetPos(0, ScrH()/10)
	self.carousel:Dock(FILL)

	self.scrollbar = self.carousel:Add("prHScrollBar")
	self.scrollbar:InvalidateParent(true)
	self.scrollbar:Dock(BOTTOM)
	self.scrollbar:SetTall(10)
	self.scrollbar:Setup()

	-- character deletion panel
	self.delete = self:AddSubpanel("delete")
	self.delete:SetTitle(nil)
	self.delete.OnSetActive = function()
		self.deleteModel:SetModel(self.character:GetModel(), character:GetData("skin", 0))
		self:CreateAnimation(self.animationTime, {
			index = 2,
			target = {backgroundFraction = 0},
			easing = "outQuint"
		})
	end

	local deleteInfo = self.delete:Add("Panel")
	deleteInfo:SetSize(parent:GetWide() * 0.5, parent:GetTall())
	deleteInfo:Dock(LEFT)

	local deleteReturn = deleteInfo:Add("ixMenuButton")
	deleteReturn:Dock(BOTTOM)
	deleteReturn:SetText("no")
	deleteReturn:SizeToContents()
	deleteReturn.DoClick = function()
		self:SetActiveSubpanel("main")
	end

	local deleteConfirm = self.delete:Add("ixMenuButton")
	deleteConfirm:Dock(BOTTOM)
	deleteConfirm:SetText("yes")
	deleteConfirm:SetContentAlignment(6)
	deleteConfirm:SizeToContents()
	deleteConfirm:SetTextColor(derma.GetColor("Error", deleteConfirm))
	deleteConfirm.DoClick = function()
		local id = self.character:GetID()

		parent:ShowNotice(1, L("deleteComplete", self.character:GetName()))
		self:Populate(id)
		self:SetActiveSubpanel("main")

		net.Start("ixCharacterDelete")
			net.WriteUInt(id, 32)
		net.SendToServer()
	end

	self.deleteModel = deleteInfo:Add("ixModelPanel")
	self.deleteModel:Dock(FILL)
	self.deleteModel:SetModel(Model(errorModel), 0)
	self.deleteModel:SetFOV(modelFOV)
	self.deleteModel.PaintModel = self.deleteModel.Paint

	local deleteNag = self.delete:Add("Panel")
	deleteNag:SetTall(parent:GetTall() * 0.5)
	deleteNag:Dock(BOTTOM)

	local deleteTitle = deleteNag:Add("DLabel")
	deleteTitle:SetFont("ixTitleFont")
	deleteTitle:SetText(L("areYouSure"):utf8upper())
	deleteTitle:SetTextColor(ix.config.Get("color"))
	deleteTitle:SizeToContents()
	deleteTitle:Dock(TOP)

	local deleteText = deleteNag:Add("DLabel")
	deleteText:SetFont("ixMenuButtonFont")
	deleteText:SetText(L("deleteConfirm"))
	deleteText:SetTextColor(color_white)
	deleteText:SetContentAlignment(7)
	deleteText:Dock(FILL)

	-- finalize setup
	self:SetActiveSubpanel("main", 0)
end

function PANEL:OnCharacterDeleted(character)
	if (self.bActive and #ix.characters == 0) then
		self:SlideDown()
	end
end

function PANEL:Populate(ignoreID)
	/*

	self.characterList:Clear()
	self.characterList.buttons = {}

	*/

	local bSelected

	self.carousel:SetOverlap(-30)
	
	
	-- loop backwards to preserve order since we're docking to the bottom
	for i = 1, #ix.characters do
		local id = ix.characters[i]
		local character = ix.char.loaded[id]

		local newCard = vgui.Create("ixCharCard", self)
		newCard:SetCharacter(character)
		
		self.carousel:AddPanel(newCard)
		
		--newCard.model:SetModel(Model(character:GetModel()), character:GetData("skin", 0))

		if (!character or character:GetID() == ignoreID) then
			continue
		end

		local index = character:GetFaction()
		local faction = ix.faction.indices[index]
		local color = faction and faction.color or color_white

		/*


		local button = self.characterList:Add("ixMenuSelectionButton")
		button:SetBackgroundColor(color)
		button:SetText(character:GetName())
		button:SizeToContents()
		button:SetButtonList(self.characterList.buttons)
		button.character = character
		button.OnSelected = function(panel)
			self:OnCharacterButtonSelected(panel)
		end

		-- select currently loaded character if available
		local localCharacter = LocalPlayer().GetCharacter and LocalPlayer():GetCharacter()

		if (localCharacter and character:GetID() == localCharacter:GetID()) then
			button:SetSelected(true)
			self.characterList:ScrollToChild(button)

			bSelected = true
		end

		*/
	end

	if (!bSelected) then
		/*

		local buttons = self.characterList.buttons

		if (#buttons > 0) then
			local button = buttons[#buttons]

			button:SetSelected(true)
			self.characterList:ScrollToChild(button)
		else
			self.character = nil
		end

		*/
	end

	self.carousel:SetScroll(500)
end

function PANEL:OnSlideUp()
	self.bActive = true
	self.carousel:Clear()
	self:Populate()
end

function PANEL:OnSlideDown()
	self.bActive = false
end

function PANEL:OnCharacterButtonSelected(panel)
	self.character = panel.character
end

function PANEL:Paint(width, height)
	derma.SkinFunc("PaintCharacterLoadBackground", self, width, height)
end

vgui.Register("ixCharMenuLoad", PANEL, "ixCharMenuPanel")


PANEL = {}

AccessorFunc(PANEL, "model", "Model", FORCE_STRING)
AccessorFunc(PANEL, "color", "Color")
AccessorFunc(PANEL, "character", "Character")

function PANEL:Init()
	self:SetSize(300, 700)

	self.image = vgui.Create("DImage", self)
	self.image:Dock(FILL)
	self.image:SetImage("vgui/project-revival/CombineBG.png")
	self.image:SetKeepAspect(true)

	self.model = vgui.Create("ixModelPanel", self)
	self.model:SetFOV(36)
	self.model:SetPos(0, 100)
	self.model:SetSize(300, 600)
	self.model:SetModel("models/gman_high.mdl")
	local modelEnt = self.model:GetEntity()
	local eyes = modelEnt:LookupAttachment("eyes")
	if modelEnt:LookupAttachment( "eyes" ) > 0 then
		modelEnt:SetEyeTarget(modelEnt:GetAttachment( modelEnt:LookupAttachment( "eyes" ) ).Pos + modelEnt:GetForward()*64 )
	end

	self:SetColor(Color(0, 0, 0, 240))

	local wholePanel = self

	self.header = vgui.Create("Panel", self)
	self.header:SetPos(0, 0)
	self.header:SetSize(300, 150)
	function self.header:Paint(w, h)
		surface.SetDrawColor(wholePanel:GetColor())
		surface.DrawRect(0, 0, w, h)
	end

	self.header:SetContentAlignment(5)

	local headerH = 150

	self.nameLbl = vgui.Create("DLabel", self.header)
	self.nameLbl:SetPos(15, -15)
	self.nameLbl:SetFont("prMenuButtonFontSmall")
	self.nameLbl:SetText("Name: ")

	self.nameLbl:SetSize(300-45, 15)
	self.nameLbl:DockMargin(0, 75 - 16, 0, 3)
	self.nameLbl:SetContentAlignment(5)
	self.nameLbl:Center()
	self.nameLbl:Dock(TOP)
	self.nameLbl:SizeToContents()
	
	self.factionLbl = vgui.Create("DLabel", self.header)
	self.factionLbl:SetPos(15, headerH/2 + 15)
	self.factionLbl:SetFont("prMenuButtonFontSmall")
	
	self.factionLbl:SetText("Faction: ")
	self.factionLbl:SetSize(300-45, 25)
	self.factionLbl:DockMargin(0, -10, 0, 0)
	self.factionLbl:Dock(TOP)
	self.factionLbl:SetContentAlignment(5)
	self.factionLbl:SizeToContents()
	
	if self.model.Entity:LookupBone("ValveBiped.Bip01_Pelvis") then
		local headpos = self.model.Entity:GetBonePosition(self.model.Entity:LookupBone("ValveBiped.Bip01_Pelvis"))
		self.model:SetLookAt(headpos)
	end

	self.controlBar = vgui.Create("Panel", self)
	self.controlBar:SetPos(0, 700-35)
	self.controlBar:SetSize(300, 42)
	self.controlBar.Paint = function(self, w, h)
		surface.SetDrawColor(0, 0, 0)
		surface.DrawRect(0, 0, w, h)
	end

	self.controlBar:Dock(BOTTOM)

	self.delBtn = vgui.Create("ixMenuButton", self.controlBar)
	self.loadBtn = vgui.Create("ixMenuButton", self.controlBar)

	self.delBtn:Dock(RIGHT)
	self.delBtn:SetWide(100)
	self.delBtn:SetFont("ixMenuMiniFont")
	self.delBtn:SetContentAlignment(6)
	self.delBtn:SetTextColor(Color(171, 0, 0))

	self.loadBtn:Dock(LEFT)
	self.loadBtn:SetWide(200)
	self.loadBtn:SetFont("ixMenuMiniFont")

	self.delBtn:SetText("Delete")
	self.loadBtn:SetText("Load")

	self.loadBtn.DoClick = function(panel)
		net.Start("ixCharacterChoose")
			net.WriteUInt(self.character:GetID(), 32)
		net.SendToServer()
	end

	function self.delBtn:DoClick()
		local carousel = wholePanel:GetParent():GetParent()
		local loadPanel = carousel:GetParent():GetParent()
		local closeFrame = Derma_Query("Do you really want to delete "..self:GetParent():GetParent():GetCharacter():GetName().."? This cannot be undone.",
		"Delete Character", "Yes", function()
			net.Start("ixCharacterDelete")
				net.WriteUInt(wholePanel:GetCharacter():GetID(), 32)
			net.SendToServer()
		
			wholePanel:Remove()
			carousel:InvalidateLayout(true)
		end, "No", function() end) 
	end
end

function PANEL:Paint()

	for _, v in ipairs(self:GetChildren()) do
		v:PaintManual()
	end

	
end

function PANEL:PaintOver(width, height)

	surface.SetDrawColor(0, 0, 0)
	if self:IsHovered() or self:IsChildHovered() then
		--surface.SetDrawColor(225, 225, 225)
	end
	
	local outlineWidth = 7
	surface.DrawOutlinedRect(0, 0, width, height, outlineWidth)
end

function PANEL:SetCharacter(character)
	self.character = character
	self.model:SetModel(character:GetModel(), character:GetData("skin", 0))
	local factionTbl = ix.faction.Get(character:GetFaction())
	if IsValid(self.nameLbl) then
		self.nameLbl:SetText(character:GetName())
	end

	local modelEnt = self.model:GetEntity()

	local bodygroups = character:GetData("groups", {})
	PrintTable(bodygroups)

	for index, value in pairs(bodygroups) do
		print("loop", index, value)
		modelEnt:SetBodygroup(index, value)
	end

	local lookat = Vector( 0, 0, 0 )

	if modelEnt:LookupAttachment("eyes") > 0 then

		local attachment = modelEnt:GetAttachment( modelEnt:LookupAttachment( "eyes" ) )
		local LocalPos, LocalAng = WorldToLocal( lookat, Angle( 0, 0, 0 ), attachment.Pos + modelEnt:GetForward()*15 + modelEnt:GetUp()*5, attachment.Ang )
		modelEnt:SetEyeTarget( attachment.Pos + modelEnt:GetForward()*15 + modelEnt:GetUp()*5 )

	end

	

	if IsValid(self.factionLbl) then
		self.factionLbl:SetText(factionTbl.name)
	end

	local color =  factionTbl.color or Color(0, 0, 0)
	color.a = 40

	self.image:SetImage(factionTbl.bgImage or "vgui/project-revival/trainstationbg.png")

	self:SetColor(color)
end

vgui.Register("ixCharCard", PANEL, "Panel")