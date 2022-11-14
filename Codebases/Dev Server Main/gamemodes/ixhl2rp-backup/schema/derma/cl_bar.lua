
-- bar manager
-- this manages positions for bar panels
local PANEL = {}

AccessorFunc(PANEL, "padding", "Padding", FORCE_NUMBER)

BAR_HEIGHT = 28

function ix.bar.Add(getValue, color, priority, identifier, icon)
	if (identifier) then
		ix.bar.Remove(identifier)
	end

	local index = #ix.bar.list + 1

	color = color or Color(math.random(150, 255), math.random(150, 255), math.random(150, 255))
	priority = priority or index

	local icons = {
		stm = "x",
		hunger = "A",
		thirst = "B",
		health = "j"
	}

	local myIcon = icons[identifier]
	print("this is what it should  be", myIcon)

	print("identifier", icons[identifier])

	ix.bar.list[index] = {
		index = index,
		color = color,	
		priority = priority,
		GetValue = getValue,
		identifier = identifier,
		icon = myIcon,
		panel = IsValid(ix.gui.bars) and ix.gui.bars:AddBar(index, color, priority, myIcon)
	}

	return priority
end

timer.Simple(1, function()

	ix.bar.Remove("armor")

	ix.bar.Get("stm").panel:SetIcon("x")
	ix.bar.Get("hunger").panel:SetIcon("A")
	ix.bar.Get("thirst").panel:SetIcon("B")

	ix.bar.Add(function()
		return math.max(LocalPlayer():Health() / LocalPlayer():GetMaxHealth(), 0)
	end, Color(200, 50, 40), 0, "health", "j")
end)

function PANEL:Init()
	self:SetSize(ScrW() * 0.35, ScrH())
	self:SetPos(4, 4)
	self:ParentToHUD()

	self.bars = {}
	self.padding = 2

	-- add bars that were registered before manager creation
	for _, v in ipairs(ix.bar.list) do
		local icons = {
			stm = "x",
			hunger = "A",
			thirst = "B",
			health = "j"
		}

		local barPanel = self:AddBar(v.index, v.color, v.priority, icons[v.identifier])

		print("identifier", v.identifier, v.index, v.icon, icons[v.identifier])
		if icons[v.identifer] then
			barPanel:SetIcon(icons[v.identifer])
		end

		v.panel = barPanel
	end
end

function PANEL:GetAll()
	return self.bars
end

function PANEL:Clear()
	for k, v in ipairs(self.bars) do
		v:Remove()

		table.remove(self.bars, k)
	end
end

function PANEL:AddBar(index, color, priority, icon)
	local panel = self:Add("ixInfoBar")
	panel:SetSize(self:GetWide(), BAR_HEIGHT)
	panel:SetVisible(false)
	panel:SetID(index)
	panel:SetColor(color)
	panel:SetPriority(priority)
	panel:SetIcon(icon)

	self.bars[#self.bars + 1] = panel
	self:Sort()

	return panel
end

function PANEL:RemoveBar(panel)
	if !IsValid(panel) then return end
	local toRemove

	for k, v in ipairs(self.bars) do
		if (v == panel) then
			toRemove = k
			break
		end
	end

	if (toRemove) then
		table.remove(self.bars, toRemove)

		-- Decrease index value for the next bars
		for i = toRemove, #self.bars do
			ix.bar.list[i].index = i
			self.bars[i]:SetID(i)
		end
	end

	panel:Remove()
	self:Sort()
end

-- sort bars by priority
function PANEL:Sort()
	table.sort(self.bars, function(a, b)
		return a:GetPriority() < b:GetPriority()
	end)
end

-- update target Y positions
function PANEL:Organize()
	local currentY = 0

	for _, v in ipairs(self.bars) do
		if (!v:IsVisible()) then
			continue
		end

		v:SetPos(0, currentY)

		currentY = currentY + self.padding + v:GetTall()
	end

	self:SetSize(self:GetWide(), currentY)
end

function PANEL:Think()
	local menu = (IsValid(ix.gui.characterMenu) and !ix.gui.characterMenu:IsClosing()) and ix.gui.characterMenu
		or IsValid(ix.gui.menu) and ix.gui.menu
	local fraction = menu and 1 - menu.currentAlpha / 255 or 1

	self:SetAlpha(255 * fraction)

	-- don't update bars when not visible
	if (fraction == 0) then
		return
	end

	local curTime = CurTime()
	local bShouldHide = hook.Run("ShouldHideBars")
	local bAlwaysShow = ix.option.Get("alwaysShowBars", false)

	for _, v in ipairs(self.bars) do
		local info = ix.bar.list[v:GetID()]
		if !info then continue end
		local realValue, barText = info.GetValue()

		if (bShouldHide or realValue == false) then
			v:SetVisible(false)
			continue
		end

		if (v:GetDelta() != realValue) then
			v:SetLifetime(curTime + 5)
		end

		if (v:GetLifetime() < curTime and !info.visible and !bAlwaysShow and !hook.Run("ShouldBarDraw", info)) then
			v:SetVisible(false)
			continue
		end

		v:SetVisible(true)
		v:SetValue(realValue)
		v:SetText("")
	end

	self:Organize()
end

function PANEL:OnRemove()
	self:Clear()
end

vgui.Register("ixInfoBarManager", PANEL, "Panel")

PANEL = {}

AccessorFunc(PANEL, "index", "ID", FORCE_NUMBER)
AccessorFunc(PANEL, "color", "Color")
AccessorFunc(PANEL, "priority", "Priority", FORCE_NUMBER)
AccessorFunc(PANEL, "value", "Value", FORCE_NUMBER)
AccessorFunc(PANEL, "delta", "Delta", FORCE_NUMBER)
AccessorFunc(PANEL, "lifetime", "Lifetime", FORCE_NUMBER)
AccessorFunc(PANEL, "icon", "Icon", FORCE_NUMBER)

function PANEL:Init()
	self.value = 0
	self.delta = 0
	self.lifetime = 0

	self.iconLbl = self:Add("DPanel")
	self.iconLbl:Dock(LEFT)
	self.iconLbl:SetWide(BAR_HEIGHT)
	wholePanel = self
	function self.iconLbl:Paint(w, h)
		--print(wholePanel.icon, wholePanel)
		draw.SimpleText(wholePanel.icon or "1", "ixPRIconsBar", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	

	self.bar = self:Add("DPanel")
	self.bar:SetPaintedManually(true)
	self.bar:Dock(FILL)
	self.bar:DockMargin(7, 7, 7, 7)
	self.bar.Paint = function(this, width, height)
		width = width * math.min(self.delta, 1)

		derma.SkinFunc("PaintInfoBar", self, width, height, self.color)
	end

	self.label = self:Add("DLabel")
	self.label:SetFont("DermaDefault")
	self.label:SetContentAlignment(5)
	self.label:SetText("")
	self.label:SetTextColor(Color(240, 240, 240))
	self.label:SetExpensiveShadow(2, Color(20, 20, 20))
	self.label:SetPaintedManually(true)
	self.label:SizeToContents()
	self.label:Dock(FILL)
	self.label:SetTextColor(Color(255, 255, 255, 0 ))
end

function PANEL:SetText(text)
	self.label:SetText("")
	self.label:SizeToContents()
end

function PANEL:Think()
	self.delta = math.Approach(self.delta, self.value, FrameTime())
end

function PANEL:Paint(width, height)
	derma.SkinFunc("PaintInfoBarBackground", self, width, height)
end

vgui.Register("ixInfoBar", PANEL, "Panel")



if (IsValid(ix.gui.bars)) then
	ix.gui.bars:Remove()
	timer.Simple(0, function()
		ix.gui.bars = vgui.Create("ixInfoBarManager")
	end)
else
	ix.gui.bars = vgui.Create("ixInfoBarManager")
end