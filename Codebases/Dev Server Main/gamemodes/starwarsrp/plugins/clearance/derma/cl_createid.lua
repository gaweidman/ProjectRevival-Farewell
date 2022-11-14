DEFINE_BASECLASS("DFrame")

local PANEL = {}
local printerID = ""

function PANEL:Init()
	self:SetBackgroundBlur(true)
	self:SetSize(400, 214)
	self:Center()
	self:SetTitle("ID Printer")

	-- Name Entry
	self.nameLabel = vgui.Create("DLabel", self)
	self.nameLabel:SetPos(8, 30)
	self.nameLabel:SetText("Name:")
	self.nameLabel:SizeToContents()
	
	self.nameEntry = vgui.Create("DTextEntry", self)
	self.nameEntry:SetPos(8, 46)
	self.nameEntry:SetSize(384, 20)
	self.nameEntry:SetMultiline(false)

	-- Organization Entry
	self.orgLabel = vgui.Create("DLabel", self)
	self.orgLabel:SetPos(8, 78)
	self.orgLabel:SetText("Organization:")
	self.orgLabel:SizeToContents()
	
	self.orgEntry = vgui.Create("DComboBox", self)
	self.orgEntry:SetPos(8, 94)
	self.orgEntry:SetSize(150, 20)

	self.orgEntry:AddChoice("Stormtrooper Corps")
	self.orgEntry:AddChoice("Navy")
	self.orgEntry:AddChoice("Army") -- We're not using army yet, we don't need this as an option.
	--self.orgEntry:AddChoice("Imperial Security Bureau") -- Removed so non-ISB can't make ISB IDs.

	-- Regiment/Role Entry
	self.roleLabel = vgui.Create("DLabel", self)
	self.roleLabel:SetPos(8, 126)
	--self.roleLabel:SetText("Regiment/Role:")
	self.roleLabel:SetText("Regiment/Role:")
	self.roleLabel:SizeToContents()
	
	self.roleEntry = vgui.Create("DComboBox", self)
	self.roleEntry:SetPos(8, 142)
	self.roleEntry:SetSize(150, 20)

	-- Print Button
	self.printButton = vgui.Create("DButton", self)
	self.printButton:SetPos(150, 179)
	self.printButton:SetSize(100, 25)
	self.printButton:SetText("Print")
	self.printButton:SetDisabled(true)

	-- Sets the options for roleEntry depending on the value of orgEntry.
	-- Value checking uses numbers because for some reason, checking it
	-- with text doesn't work. No idea why.
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
		end

		if (self.nameEntry != "" and self.roleEntry:GetValue() != "") then 
			self.printButton:SetDisabled(false)
		else
			self.printButton:SetDisabled(true)
		end
	end
	 
	self.roleEntry.OnSelect = function(index, value, data)
		if (self.nameEntry != "" and self.orgEntry:GetValue() != "") then 
			self.printButton:SetDisabled(false)
		else
			self.printButton:SetDisabled(true)
		end
	end

	self.nameEntry.OnChange = function(index, value, data)
		if (self.roleEntry:GetValue() != "" and self.orgEntry:GetValue() != "") then 
			self.printButton:SetDisabled(false)
		else
			self.printButton:SetDisabled(true)
		end
	end

	self.printButton.DoClick = function()
		netstream.Start("PrintIDChip", {self.nameEntry:GetValue(), self.orgEntry:GetSelected(),  self.roleEntry:GetSelected(), printerID})
	end

	self:MakePopup()
end

function PANEL:Populate(data)
	printerID = data
end

vgui.Register("ixCreateID", PANEL, "DFrame")