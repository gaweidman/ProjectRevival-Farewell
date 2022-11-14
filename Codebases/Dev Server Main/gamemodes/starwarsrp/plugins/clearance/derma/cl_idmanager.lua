DEFINE_BASECLASS("DFrame")

local PANEL = {}
local managerID
local clrTbl
local name
local rank
local org
local role

function PANEL:Init()
	self:SetBackgroundBlur(true)
	self:SetSize(400, 411)
	self:Center()
	self:SetTitle("ID Printer")

    -- Name Entry
    do
        self.nameLabel = vgui.Create("DLabel", self)
        self.nameLabel:SetPos(8, 30)
        self.nameLabel:SetText("Name:")
        self.nameLabel:SizeToContents()
    
	
        self.nameEntry = vgui.Create("DTextEntry", self)
        self.nameEntry:SetPos(8, 46)
        self.nameEntry:SetSize(384, 20)
        self.nameEntry:SetMultiline(false)
    end

    -- Organization Entry
    do
        self.orgLabel = vgui.Create("DLabel", self)
        self.orgLabel:SetPos(8, 78)
        self.orgLabel:SetText("Organization:")
        self.orgLabel:SizeToContents()
        
        self.orgEntry = vgui.Create("DComboBox", self)
        self.orgEntry:SetPos(8, 94)
        self.orgEntry:SetSize(150, 20)

        self.orgEntry:AddChoice("Stormtrooper Corps")
        self.orgEntry:AddChoice("Navy")
        self.orgEntry:AddChoice("Imperial Security Bureau")
        self.orgEntry:AddChoice("Army") -- We're not using army yet, we don't need this as an option.
    end
	

    -- Regiment/Role Entry
    do
        self.roleLabel = vgui.Create("DLabel", self)
        self.roleLabel:SetPos(8, 126)
        --self.roleLabel:SetText("Regiment/Role:")
        self.roleLabel:SetText("Regiment/Role:")
        self.roleLabel:SizeToContents()
        
        self.roleEntry = vgui.Create("DComboBox", self)
        self.roleEntry:SetPos(8, 142)
        self.roleEntry:SetSize(150, 20)
    end

    -- Rank Entry
    do
        self.rankLabel = vgui.Create("DLabel", self)
        self.rankLabel:SetPos(8, 174)
        self.rankLabel:SetText("Rank:")
        self.rankLabel:SizeToContents()

        self.rankEntry = vgui.Create("DTextEntry", self)
        self.rankEntry:SetPos(8, 190)
        self.rankEntry:SetSize(150, 20)
        self.rankEntry:SetMultiline(false)
    end

    -- Clearance Level Entry
    do
        -- Control Clearance
        self.ctrlLabel = vgui.Create("DLabel", self)
        self.ctrlLabel:SetPos(8, 222)
        self.ctrlLabel:SetText("Control Clearance:")
        self.ctrlLabel:SizeToContents()

        self.ctrlEntry = vgui.Create("DNumberWang", self)
        self.ctrlEntry:SetPos(8, 238)
        self.ctrlEntry:SetSize(100, 20)
        self.ctrlEntry:SetMin(0)
        self.ctrlEntry:SetMax(4)

        -- System Clearance
        self.sysLabel = vgui.Create("DLabel", self)
        self.sysLabel:SetPos(8, 270)
        self.sysLabel:SetText("System Clearance:")
        self.sysLabel:SizeToContents()

        self.sysEntry = vgui.Create("DNumberWang", self)
        self.sysEntry:SetPos(8, 286)
        self.sysEntry:SetSize(100, 20)
        self.sysEntry:SetMin(0)
        self.sysEntry:SetMax(3)

        -- ISB Clearance
        self.isbLabel = vgui.Create("DLabel", self)
        self.isbLabel:SetPos(8, 318)
        self.isbLabel:SetText("ISB Clearance:")
        self.isbLabel:SizeToContents()

        self.isbEntry = vgui.Create("DNumberWang", self)
        self.isbEntry:SetPos(8, 334)
        self.isbEntry:SetSize(100, 20)
        self.isbEntry:SetMin(0)
        self.isbEntry:SetMax(3)
    end

    -- Print Button
    do
        self.updateButton = vgui.Create("DButton", self)
        self.updateButton:SetPos(150, 371)
        self.updateButton:SetSize(100, 25)
        self.updateButton:SetText("Update")
    end

	-- Sets the options for roleEntry depending on the value of orgEntry.
	-- Value checking uses numbers because for some reason, checking it
    -- with text doesn't work. No idea why.
    do
        self.orgEntry.OnSelect = function(index, value, data)
            if (value == 1) then -- Stormtrooper
                self.roleEntry:Clear()
                self.roleEntry:AddChoice("Shock Trooper")
                self.roleEntry:AddChoice("Shadow Trooper")
                self.roleEntry:AddChoice("Range Trooper")
                self.roleEntry:AddChoice("Incinerator Trooper")
                self.roleEntry:AddChoice("Stormtrooper")
                self.roleEntry:AddChoice("Storm Commando")
                self.roleEntry:AddChoice("Scout Trooper")
                self.roleEntry:AddChoice("Skytrooper")
            elseif (value == 2) then -- Navy
                self.roleEntry:Clear()
                self.roleEntry:AddChoice("Crewman")
                self.roleEntry:AddChoice("Technician")
                self.roleEntry:AddChoice("Medic")
                self.roleEntry:AddChoice("Gunner")
                self.roleEntry:AddChoice("Pilot")
                self.roleEntry:AddChoice("Trooper")
            elseif (value == 3) then -- ISB
                self.roleEntry:Clear()
                self.roleEntry:AddChoice("Officer")
                self.roleEntry:AddChoice("Death Trooper")
            elseif (value == 4) then -- ISB
                self.roleEntry:Clear()
                self.roleEntry:AddChoice("Infantry")
                self.roleEntry:AddChoice("Pilot")
                self.roleEntry:AddChoice("Medic")
            end

            if (self.nameEntry != "" and self.roleEntry:GetValue() != "") then 
                self.updateButton:SetDisabled(false)
            else
                self.updateButton:SetDisabled(true)
            end
        end
        
        self.roleEntry.OnSelect = function(index, value, data)
            if (self.nameEntry != "" and self.orgEntry:GetValue() != "") then 
                self.updateButton:SetDisabled(false)
            else
                self.updateButton:SetDisabled(true)
            end
        end

        self.nameEntry.OnChange = function(index, value, data)
            if (self.roleEntry:GetValue() != "" and self.orgEntry:GetValue() != "") then 
                self.updateButton:SetDisabled(false)
            else
                self.updateButton:SetDisabled(true)
            end
        end
    end

    -- Print ID
    self.updateButton.DoClick = function()
        local newClrTbl = {
            ["control"] = self.ctrlEntry:GetValue(),
            ["systems"] = self.sysEntry:GetValue(),
            ["isb"] = self.isbEntry:GetValue()
        }

		netstream.Start("UpdateID", {
            self.nameEntry:GetValue(),
            self.orgEntry:GetSelected(),
            self.roleEntry:GetSelected(),
            newClrTbl,
            managerID,
            self.rankEntry:GetValue(),
            
        })

        self:Close()
    end


	self:MakePopup()
end

function PANEL:Populate(data)
    local classIndex = data[7]
    managerID = data[1]
    clrTbl = data[2]
    name = data[3]
    rank = data[4]
    org = data[5]
    role = data[6]

    if (org == "Stormtrooper Corps") then
        self.roleEntry:AddChoice("Shock Trooper")
        self.roleEntry:AddChoice("Shadow Trooper")
        self.roleEntry:AddChoice("Range Trooper")
        self.roleEntry:AddChoice("Incinerator Trooper")
        self.roleEntry:AddChoice("Stormtrooper")
        self.roleEntry:AddChoice("Storm Commando")
        self.roleEntry:AddChoice("Scout Trooper")
        self.roleEntry:AddChoice("Skytrooper")
    elseif (org == "Navy") then
        self.roleEntry:AddChoice("Crewman")
        self.roleEntry:AddChoice("Technician")
        self.roleEntry:AddChoice("Medic")
        self.roleEntry:AddChoice("Gunner")
        self.roleEntry:AddChoice("Pilot")
        self.roleEntry:AddChoice("Trooper")
    elseif (org == "Imperial Security Bureau") then
        self.roleEntry:AddChoice("Officer")
        self.roleEntry:AddChoice("Death Trooper")
    elseif (org == "Army") then
        self.roleEntry:AddChoice("Infantry")
        self.roleEntry:AddChoice("Pilot")
        self.roleEntry:AddChoice("Medic")
    end

    self.nameEntry:SetValue(name)
    self.rankEntry:SetValue(rank)
    self.orgEntry:SetValue(org)
    self.roleEntry:SetValue(role)
    self.ctrlEntry:SetValue(clrTbl["control"])
    self.sysEntry:SetValue(clrTbl["systems"])
    self.isbEntry:SetValue(clrTbl["isb"])
end

vgui.Register("ixIDManager", PANEL, "DFrame")