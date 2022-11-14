local PLUGIN = PLUGIN

local PANEL = {}

AccessorFunc(PANEL, "itemID", "ItemID", FORCE_NUMBER)

PANEL.itemName = ""
PANEL.editing = nil

function PANEL:Init()
    local padding = 8
    local margin = 8
    local panelSize = {
        ["x"] = 650,
        ["y"] = 749,
        ["tb"] = 24,
        ["bb"] = 1,
        ["sb"] = 1
    }

    --self:SetPos( ScrW()/2 - 950/2, ScrH()/2 - 750/2) 
    self:SetSize( panelSize.x, panelSize.y ) 
    self:Center()
    
    self:SetTitle( "Paper" )
    
    self.text = self:Add("DTextEntry")
    self.text:SetPos(1 + padding, 24 + padding)
    self.text:SetSize(650 - 2 * padding - 2 * panelSize.sb, 
        panelSize.y - (24 + padding) - padding - panelSize.bb - 80)
    self.text:SetVerticalScrollbarEnabled(true)
    self.text:SetMultiline(true)

    self.saveButton = self:Add("DButton")
    self.saveButton:SetText("Save & Exit")
    self.saveButton:SetPos(1 + padding,
        panelSize.y - 1 - 80 - padding + margin)
    self.saveButton:SetSize(120, ((24 + padding) + padding + 1 + 80 - (3 * margin)) / 4 + margin)
    self.saveButton.DoClick = function()
        if (self.editing) then
            --itemID, text, pickupOthers, editableOthers
            netstream.Start("ixWritingEdit", self.itemID, self.text:GetValue():sub(1, PLUGIN.maxLength), self.pickupCheck:GetChecked(), self.editCheck:GetChecked())
            self:Close()
        end
    end

    
    self.exitButton = self:Add("DButton")
    self.exitButton:SetText("Exit without Saving")
    self.exitButton:SetPos(1 + padding,
        panelSize.y - 1 - 80 - padding + margin + (((24 + padding) + padding + 1 + 80 - (3 * margin)) / 4 + margin) + margin)
    self.exitButton:SetSize(120, ((24 + padding) + padding + 1 + 80 - (3 * margin)) / 4 + margin)
    self.exitButton.DoClick = function()
        self:Close()
    end

    
    self.pickupCheck = self:Add("DCheckBoxLabel")
    self.pickupCheck:SetText("Can Be Picked Up by Others")
    self.pickupCheck:SetPos(475,
        panelSize.y - 1 - 80 - padding + margin)
    
    self.editCheck = self:Add("DCheckBoxLabel")
    self.editCheck:SetText("Can Be Edited by Others")
    self.editCheck:SetPos(475, 
        panelSize.y - 1 - 80 - padding + margin + 15 + margin)

    PLUGIN.panel = self

    self:MakePopup()
    self:SetBackgroundBlur( true )
end

function PANEL:SetText(text)
	self.text:SetValue(text)
end

function PANEL:SetupCheckboxes(pickup, edit)
    self.pickupCheck:SetChecked(pickup)
    self.editCheck:SetChecked(edit)
end

function PANEL:SetFont(font)
    self.text:SetFont(font)
end

function PANEL:SetEditing(editing)
    if (not editing) then
        self.saveButton:SetDisabled(true)
    end

    self.editing = editing
end

vgui.Register("ixImprovedPaper", PANEL, "DFrame")