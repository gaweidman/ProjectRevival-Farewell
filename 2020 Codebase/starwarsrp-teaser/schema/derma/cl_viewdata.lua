
hook.Add("LoadFonts", "ixViewData", function()
	surface.CreateFont("ixViewData", {
		font = "Courier New",
		size = 16,
		antialias = true,
		weight = 400
	})
end)

local animationTime = 1
DEFINE_BASECLASS("DFrame")

local PANEL = {}

AccessorFunc(PANEL, "bCommitOnClose", "CommitOnClose", FORCE_BOOL)

function PANEL:Init()
	self:SetBackgroundBlur(true)
	self:SetSize(ScrW() / 4 > 200 and ScrW() / 4 or ScrW() / 2, ScrH() / 2 > 300 and ScrH() / 2 or ScrH())
	self:Center()

	self.nameLabel = vgui.Create("DLabel", self)
	self.nameLabel:SetFont("BudgetLabel")
	self.nameLabel:SizeToContents()
	self.nameLabel:Dock(TOP)

    self.tabSheet = vgui.Create("DPropertySheet", self)
	self.tabSheet:SizeToContents()
    self.tabSheet:Dock(FILL)

    self.adminPanel = nil
    self.adminTab = nil
    self.adminText = nil
end

function PANEL:Populate(target, data)
    self.nameLabel:SetText(target:GetName().."'s Data" , self.tabSheet)

    self.target = target
    self.data = data

    if (data.securityAuth) then
        self.securityPanel = vgui.Create("DPanel")

        self.securityText = vgui.Create("DTextEntry", self.securityPanel)
        self.securityText:SetMultiline(true)
        self.securityText:Dock(FILL)
        self.securityText:SetFont("ixViewData")
        self.securityText:SetValue(data.securityData)

        self.securityTab = self.tabSheet:AddSheet("Security", self.securityPanel)
    end

    if (data.isbAuth) then
        self.isbPanel = vgui.Create("DPanel")

        self.isbText = vgui.Create("DTextEntry", self.isbPanel)
        self.isbText:SetMultiline(true)
        self.isbText:Dock(FILL)
        self.isbText:SetFont("ixViewData")
        self.isbText:SetValue(data.isbData)
        
        self.isbTab = self.tabSheet:AddSheet("ISB", self.isbPanel)
    end

    -- This is deprecated, I'm going to handle it with player data.
    if (data.staffAuth) then
        self.staffPanel = vgui.Create("DPanel")

        self.staffTab = self.tabSheet:AddSheet("ISB", self.self.staffPanel)

        self.staffText = vgui.Create("DTextEntry", self.staffPanel)
        self.staffText:SetMultiline(true)
        self.staffText:Dock(FILL)
        self.staffText:SetFont("ixViewData")
        self.staffText:SetValue(data.staffData)
    end

    self:MakePopup()
end

function PANEL:OnClose()
    print("testing my close")
    if (self.data.isbAuth) then
        netstream.Start("SaveViewData", self.target, {
            ["securityAuth"] = self.data.securityAuth,
            ["securityData"] = self.securityText:GetValue(),
            ["isbAuth"] = self.data.isbAuth,
            ["isbData"] = self.isbText:GetValue(),
            ["staffAuth"] = self.data.staffAuth,
            ["staffData"] = nil
        })
    elseif (self.data.securityAuth) then
        netstream.Start("SaveViewData", self.target, {
            ["securityAuth"] = self.data.securityAuth,
            ["securityData"] = self.securityText:GetValue(),
            ["isbAuth"] = self.data.isbAuth,
            ["isbData"] = nil,
            ["staffAuth"] = self.data.staffAuth,
            ["staffData"] = nil
        })
    end
    
end


vgui.Register("ixViewData", PANEL, "DFrame")