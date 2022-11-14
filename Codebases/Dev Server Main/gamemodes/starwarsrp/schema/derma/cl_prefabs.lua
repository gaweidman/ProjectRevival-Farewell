DEFINE_BASECLASS("DFrame")

local PANEL = {}

function PANEL:Init()
    self:SetSize(self:GetParent():GetSize()+15+2, (16+8)+(18)+10)
    local SizeX, SizeY = self:GetSize()
    local fontHeight = draw.GetFontHeight("DermaBigger")
    self.image = vgui.Create("DImage", self)
    self.image:SetImage("icon16/add.png")
    self.image:SetSize(16+8, 16 + 8)
    self.image:SetPos(5, 5 + (18))
    --self.image:Dock(LEFT)
    --self.image:SetSize(16, 16)

    --self.image:Dock(FILL)
    self.label = vgui.Create("DLabel", self)
    self.label:SetText("CCA.C17-UNION.i5.17005 added a new violation.")
    self.label:SetPos(16 + 8 + 12, 7+(18))
    self.label:SetColor(Color(0, 0, 0, 255))
    self.label:SetFont("DermaBigger")
    self.label:SizeToContents()

    self.timestamp = vgui.Create("DLabel", self)
    self.timestamp:SetText("01/01/21 00:00")
    self.timestamp:SetPos(0, 0)
    self.timestamp:SizeToContents()
    
end

function PANEL:Paint()
    draw.RoundedBox(0, 0, (18), self:GetSize(), self:GetSize() - (10), Color(86, 86, 86, 255))
    if (!self:IsHovered()) then
        draw.RoundedBox(0, 1, 1+(18), self:GetSize() - 2, 24 + 8, Color(255, 255, 255, 255))
    else   
        draw.RoundedBox(0, 1, 1+(18), self:GetSize() - 2, 24 + 8, Color(218, 218, 218, 255))
    end
end

function PANEL:OnMouseReleased()
    self:DoClick()
end

function PANEL:DoClick()
    local centralFrame = self:GetParent():GetParent():GetParent():GetParent()
    if (self.logType == "AddAct") then

        local DViewLoyalAct = vgui.Create( "DFrame", self )
        centralFrame:ShowPopup({DAddLoyalAct})
        DViewLoyalAct:SetPos( ScrW()/2 - 250/2, ScrH()/2 - 350/2) 
        DViewLoyalAct:SetSize( 250, 350 ) 
        DViewLoyalAct:SetTitle( "New Loyal Act" ) 
        DViewLoyalAct:SetVisible( true ) 
        DViewLoyalAct:SetDraggable( true ) 
        DViewLoyalAct:ShowCloseButton( true ) 
        DViewLoyalAct:SetDeleteOnClose( true )
        DViewLoyalAct:MakePopup()

        -- TOTAL LP
        local DActL = vgui.Create("DLabel", DViewLoyalAct )
        DActL:SetText( "Loyal Act" )		
        DActL:SetPos( 10, 25 )		
        DActL:SetSize( 250, 30 )

        -- LOYAL ACTS
        local DAct = vgui.Create( "DTextEntry", DViewLoyalAct ) 
        DAct:SetPos(10, 50)
        DAct:SetSize(230, 20)

        -- Loyalist Points
        local DLPL = vgui.Create("DLabel", DViewLoyalAct )
        DLPL:SetText( "Loyalist Points" )		
        DLPL:SetPos( 10, 75 )		
        DLPL:SetSize( 250, 30 )

        local DLP = vgui.Create("DNumberWang", DViewLoyalAct)
        DLP:SetPos(10, 100)
        DLP:SetSize(100, 20)
        DLP:SetMin(0)
        DLP:SetMax(15)

        -- NOTES
        local DNotesL = vgui.Create("DLabel", DViewLoyalAct )
        DNotesL:SetText( "Notes" )		
        DNotesL:SetPos( 10, 130 )		
        DNotesL:SetSize( 250, 30 )

        local DNotes = vgui.Create( "DTextEntry", DViewLoyalAct ) 
        DNotes:SetPos(10, 155)
        DNotes:SetSize( 230, 350 - 165 )
        DNotes:SetMultiline(true)
        DNotes:SetVerticalScrollbarEnabled(true)

        DAct:SetValue(self.data.data.name)
        DLP:SetValue(self.data.data.lp)
        DNotes:SetValue(self.data.data.notes)
        DLP:SetEditable(false)
    elseif (self.logType == "AddVio") then
        local DAddViolation = vgui.Create( "DFrame", self )
        centralFrame:ShowPopup({DAddViolation})
        DAddViolation:SetPos( ScrW()/2 - 250/2, ScrH()/2 - 350/2) 
        DAddViolation:SetSize( 250, 350 ) 
        DAddViolation:SetTitle( "New Violation" ) 
        DAddViolation:SetVisible( true ) 
        DAddViolation:SetDraggable( true ) 
        DAddViolation:ShowCloseButton( true ) 
        DAddViolation:SetDeleteOnClose( true )
        DAddViolation:MakePopup()
        --DAddViolation:Center()

        -- TOTAL LP
        local DVioL = vgui.Create("DLabel", DAddViolation )
        DVioL:SetText( "Violation" )		
        DVioL:SetPos( 10, 25 )		
        DVioL:SetSize( 250, 30 )

        -- VIOLATION
        local DVName = vgui.Create( "DTextEntry", DAddViolation ) 
        DVName:SetPos(10, 50)
        DVName:SetSize( 230, 20)

        -- VIOLATION LEVEL
        local DLvlL = vgui.Create("DLabel", DAddViolation )
        DLvlL:SetText( "Violation Level" )		
        DLvlL:SetPos( 10, 75 )		
        DLvlL:SetSize( 250, 30 )

        local DLvl = vgui.Create("DNumberWang", DAddViolation)
        DLvl:SetPos(10, 100)
        DLvl:SetSize(100, 20)
        DLvl:SetMin(1)
        DLvl:SetMax(7)

        -- Loyalist Points
        local DLPL = vgui.Create("DLabel", DAddViolation )
        DLPL:SetText( "Loyalist Points" )		
        DLPL:SetPos( 350-210, 75 )		
        DLPL:SetSize( 250, 30 )

        local DLP = vgui.Create("DNumberWang", DAddViolation)
        DLP:SetPos(350 - 210, 100)
        DLP:SetSize(100, 20)
        DLP:SetMin(-15)
        DLP:SetMax(0)

        -- NOTES
        local DNotesL = vgui.Create("DLabel", DAddViolation )
        DNotesL:SetText( "Notes" )		
        DNotesL:SetPos( 10, 130 )		
        DNotesL:SetSize( 250, 30 )

        local DNotes = vgui.Create( "DTextEntry", DAddViolation ) 
        DNotes:SetPos(10, 155)
        DNotes:SetSize( 230, 350 - 165 )
        DNotes:SetMultiline(true)
        DNotes:SetVerticalScrollbarEnabled(true)

        DVName:SetValue(self.data.data.name)
        DLvl:SetValue(self.data.data.lvl)
        DLP:SetValue(self.data.data.lp)
        DNotes:SetValue(self.data.data.notes)
        DLvl:SetEditable(false)
        DLP:SetEditable(false)
    elseif (self.logType == "EditAct") then
        local DViewLoyalActOld = vgui.Create( "DFrame", self )
        local DViewLoyalActNew = vgui.Create( "DFrame", self )

        centralFrame:ShowPopup({DViewLoyalActOld, DViewLoyalActNew})

        DViewLoyalActOld:SetPos( ScrW()/2 - 250 - 50, ScrH()/2 - 350/2) 
        DViewLoyalActOld:SetSize( 250, 350 ) 
        DViewLoyalActOld:SetTitle( "Old Loyal Act" ) 
        DViewLoyalActOld:SetVisible( true ) 
        DViewLoyalActOld:SetDraggable( true ) 
        DViewLoyalActOld:ShowCloseButton( true ) 
        DViewLoyalActOld:SetDeleteOnClose( true )
        DViewLoyalActOld:MakePopup()

        -- TOTAL LP
        local DActLOld = vgui.Create("DLabel", DViewLoyalActOld )
        DActLOld:SetText( "Loyal Act" )		
        DActLOld:SetPos( 10, 25 )		
        DActLOld:SetSize( 250, 30 )

        -- LOYAL ACTS
        local DActOld = vgui.Create( "DTextEntry", DViewLoyalActOld ) 
        DActOld:SetPos(10, 50)
        DActOld:SetSize(230, 20)

        -- Loyalist Points
        local DLPLOld = vgui.Create("DLabel", DViewLoyalActOld )
        DLPLOld:SetText( "Loyalist Points" )		
        DLPLOld:SetPos( 10, 75 )		
        DLPLOld:SetSize( 250, 30 )

        local DLPOld = vgui.Create("DNumberWang", DViewLoyalActOld )
        DLPOld:SetPos(10, 100)
        DLPOld:SetSize(100, 20)
        DLPOld:SetMin(0)
        DLPOld:SetMax(15)

        -- NOTES
        local DNotesLOld = vgui.Create("DLabel", DViewLoyalActOld )
        DNotesLOld:SetText( "Notes" )		
        DNotesLOld:SetPos( 10, 130 )		
        DNotesLOld:SetSize( 250, 30 )

        local DNotesOld = vgui.Create( "DTextEntry", DViewLoyalActOld ) 
        DNotesOld:SetPos(10, 155)
        DNotesOld:SetSize( 230, 350 - 165 )
        DNotesOld:SetMultiline(true)
        DNotesOld:SetVerticalScrollbarEnabled(true)

        DActOld:SetValue(self.data.data.oldVer.name)
        DLPOld:SetValue(self.data.data.oldVer.lp)
        DNotesOld:SetValue(self.data.data.oldVer.notes)
        DLPOld:SetEditable(false)
        
        DViewLoyalActNew:SetPos( ScrW()/2 + 50, ScrH()/2 - 350/2) 
        DViewLoyalActNew:SetSize( 250, 350 ) 
        DViewLoyalActNew:SetTitle( "New Loyal Act" ) 
        DViewLoyalActNew:SetVisible( true ) 
        DViewLoyalActNew:SetDraggable( true ) 
        DViewLoyalActNew:ShowCloseButton( true ) 
        DViewLoyalActNew:SetDeleteOnClose( true )
        DViewLoyalActNew:MakePopup()

        -- TOTAL LP
        local DActLNew = vgui.Create("DLabel", DViewLoyalActNew )
        DActLNew:SetText( "Loyal Act" )		
        DActLNew:SetPos( 10, 25 )		
        DActLNew:SetSize( 250, 30 )

        -- LOYAL ACTS
        local DActNew = vgui.Create( "DTextEntry", DViewLoyalActNew ) 
        DActNew:SetPos(10, 50)
        DActNew:SetSize(230, 20)

        -- Loyalist Points
        local DLPLNew = vgui.Create("DLabel", DViewLoyalActNew )
        DLPLNew:SetText( "Loyalist Points" )		
        DLPLNew:SetPos( 10, 75 )		
        DLPLNew:SetSize( 250, 30 )

        local DLPNew = vgui.Create("DNumberWang", DViewLoyalActNew )
        DLPNew:SetPos(10, 100)
        DLPNew:SetSize(100, 20)
        DLPNew:SetMin(0)
        DLPNew:SetMax(15)

        -- NOTES
        local DNotesLNew = vgui.Create("DLabel", DViewLoyalActNew )
        DNotesLNew:SetText( "Notes" )		
        DNotesLNew:SetPos( 10, 130 )		
        DNotesLNew:SetSize( 250, 30 )

        local DNotesNew = vgui.Create( "DTextEntry", DViewLoyalActNew ) 
        DNotesNew:SetPos(10, 155)
        DNotesNew:SetSize( 230, 350 - 165 )
        DNotesNew:SetMultiline(true)
        DNotesNew:SetVerticalScrollbarEnabled(true)

        DActNew:SetValue(self.data.data.newVer.name)
        DLPNew:SetValue(self.data.data.newVer.lp)
        DNotesNew:SetValue(self.data.data.newVer.notes)
        DLPNew:SetEditable(false) 
    elseif (self.logType == "EditVio") then
        local DOldViolation = vgui.Create( "DFrame", self )
        local DNewViolation = vgui.Create( "DFrame", self )

        centralFrame:ShowPopup({DOldViolation, DNewViolation})

        DOldViolation:SetPos( ScrW()/2 - 250 - 50, ScrH()/2 - 350/2) 
        DOldViolation:SetSize( 250, 350 ) 
        DOldViolation:SetTitle( "Old Violation" ) 
        DOldViolation:SetVisible( true ) 
        DOldViolation:SetDraggable( true ) 
        DOldViolation:ShowCloseButton( true ) 
        DOldViolation:SetDeleteOnClose( true )
        DOldViolation:MakePopup()
        --DAddViolation:Center()

        -- TOTAL LP
        local DOldVioL = vgui.Create("DLabel", DOldViolation )
        DOldVioL:SetText( "Violation" )		
        DOldVioL:SetPos( 10, 25 )		
        DOldVioL:SetSize( 250, 30 )

        -- VIOLATION
        local DOldVName = vgui.Create( "DTextEntry", DOldViolation ) 
        DOldVName:SetPos(10, 50)
        DOldVName:SetSize( 230, 20)

        -- VIOLATION LEVEL
        local DOldLvlL = vgui.Create("DLabel", DOldViolation )
        DOldLvlL:SetText( "Violation Level" )		
        DOldLvlL:SetPos( 10, 75 )		
        DOldLvlL:SetSize( 250, 30 )

        local DOldLvl = vgui.Create("DNumberWang", DOldViolation)
        DOldLvl:SetPos(10, 100)
        DOldLvl:SetSize(100, 20)
        DOldLvl:SetMin(1)
        DOldLvl:SetMax(7)

        -- Loyalist Points
        local DOldLPL = vgui.Create("DLabel", DOldViolation )
        DOldLPL:SetText( "Loyalist Points" )		
        DOldLPL:SetPos( 350-210, 75 )		
        DOldLPL:SetSize( 250, 30 )

        local DOldLP = vgui.Create("DNumberWang", DOldViolation)
        DOldLP:SetPos(350 - 210, 100)
        DOldLP:SetSize(100, 20)
        DOldLP:SetMin(-15)
        DOldLP:SetMax(0)

        -- NOTES
        local DOldNotesL = vgui.Create("DLabel", DOldViolation )
        DOldNotesL:SetText( "Notes" )		
        DOldNotesL:SetPos( 10, 130 )		
        DOldNotesL:SetSize( 250, 30 )

        local DOldNotes = vgui.Create( "DTextEntry", DOldViolation) 
        DOldNotes:SetPos(10, 155)
        DOldNotes:SetSize( 230, 350 - 165 )
        DOldNotes:SetMultiline(true)
        DOldNotes:SetVerticalScrollbarEnabled(true)

        DOldVName:SetValue(self.data.data.oldVer.name)
        DOldLvl:SetValue(self.data.data.oldVer.lvl)
        DOldLP:SetValue(self.data.data.oldVer.lp)
        DOldNotes:SetValue(self.data.data.oldVer.notes)

        DOldLvl:SetEditable(false)
        DOldLP:SetEditable(false)

        DNewViolation:SetPos( ScrW()/2 + 50, ScrH()/2 - 350/2) 
        DNewViolation:SetSize( 250, 350 ) 
        DNewViolation:SetTitle( "New Violation" )
        DNewViolation:SetVisible( true ) 
        DNewViolation:SetDraggable( true ) 
        DNewViolation:ShowCloseButton( true ) 
        DNewViolation:SetDeleteOnClose( true )
        DNewViolation:MakePopup()
        --DAddViolation:Center()

        -- TOTAL LP
        local DNewVioL = vgui.Create("DLabel", DNewViolation )
        DNewVioL:SetText( "Violation" )		
        DNewVioL:SetPos( 10, 25 )		
        DNewVioL:SetSize( 250, 30 )

        -- VIOLATION
        local DNewVName = vgui.Create( "DTextEntry", DNewViolation ) 
        DNewVName:SetPos(10, 50)
        DNewVName:SetSize( 230, 20)

        -- VIOLATION LEVEL
        local DNewLvlL = vgui.Create("DLabel", DNewViolation )
        DNewLvlL:SetText( "Violation Level" )		
        DNewLvlL:SetPos( 10, 75 )		
        DNewLvlL:SetSize( 250, 30 )

        local DNewLvl = vgui.Create("DNumberWang", DNewViolation)
        DNewLvl:SetPos(10, 100)
        DNewLvl:SetSize(100, 20)
        DNewLvl:SetMin(1)
        DNewLvl:SetMax(7)

        -- Loyalist Points
        local DNewLPL = vgui.Create("DLabel", DNewViolation )
        DNewLPL:SetText( "Loyalist Points" )		
        DNewLPL:SetPos( 350-210, 75 )		
        DNewLPL:SetSize( 250, 30 )

        local DNewLP = vgui.Create("DNumberWang", DNewViolation)
        DNewLP:SetPos(350 - 210, 100)
        DNewLP:SetSize(100, 20)
        DNewLP:SetMin(-15)
        DNewLP:SetMax(0)

        -- NOTES
        local DNewNotesL = vgui.Create("DLabel", DNewViolation )
        DNewNotesL:SetText( "Notes" )		
        DNewNotesL:SetPos( 10, 130 )		
        DNewNotesL:SetSize( 250, 30 )

        local DNewNotes = vgui.Create( "DTextEntry", DNewViolation) 
        DNewNotes:SetPos(10, 155)
        DNewNotes:SetSize( 230, 350 - 165 )
        DNewNotes:SetMultiline(true)
        DNewNotes:SetVerticalScrollbarEnabled(true)

        DNewVName:SetValue(self.data.data.newVer.name)
        DNewLvl:SetValue(self.data.data.newVer.lvl)
        DNewLP:SetValue(self.data.data.newVer.lp)
        DNewNotes:SetValue(self.data.data.newVer.notes)

        DNewLvl:SetEditable(false)
        DNewLP:SetEditable(false)
    elseif (self.logType == "DelAct") then
        local DViewLoyalAct = vgui.Create( "DFrame", self )
        centralFrame:ShowPopup({DViewLoyalAct})
        DViewLoyalAct:SetPos( ScrW()/2 - 250/2, ScrH()/2 - 350/2) 
        DViewLoyalAct:SetSize( 250, 350 ) 
        DViewLoyalAct:SetTitle( "Old Loyal Act" ) 
        DViewLoyalAct:SetVisible( true ) 
        DViewLoyalAct:SetDraggable( true ) 
        DViewLoyalAct:ShowCloseButton( true ) 
        DViewLoyalAct:SetDeleteOnClose( true )
        DViewLoyalAct:MakePopup()

        -- TOTAL LP
        local DActL = vgui.Create("DLabel", DViewLoyalAct )
        DActL:SetText( "Loyal Act" )		
        DActL:SetPos( 10, 25 )		
        DActL:SetSize( 250, 30 )

        -- LOYAL ACTS
        local DAct = vgui.Create( "DTextEntry", DViewLoyalAct ) 
        DAct:SetPos(10, 50)
        DAct:SetSize(230, 20)

        -- Loyalist Points
        local DLPL = vgui.Create("DLabel", DViewLoyalAct )
        DLPL:SetText( "Loyalist Points" )		
        DLPL:SetPos( 10, 75 )		
        DLPL:SetSize( 250, 30 )

        local DLP = vgui.Create("DNumberWang", DViewLoyalAct)
        DLP:SetPos(10, 100)
        DLP:SetSize(100, 20)
        DLP:SetMin(0)
        DLP:SetMax(15)

        -- NOTES
        local DNotesL = vgui.Create("DLabel", DViewLoyalAct )
        DNotesL:SetText( "Notes" )		
        DNotesL:SetPos( 10, 130 )		
        DNotesL:SetSize( 250, 30 )

        local DNotes = vgui.Create( "DTextEntry", DViewLoyalAct ) 
        DNotes:SetPos(10, 155)
        DNotes:SetSize( 230, 350 - 165 )
        DNotes:SetMultiline(true)
        DNotes:SetVerticalScrollbarEnabled(true)

        DAct:SetValue(self.data.data.name)
        DLP:SetValue(self.data.data.lp)
        DNotes:SetValue(self.data.data.notes)
        DLP:SetEditable(false)
    elseif (self.logType == "DelVio") then
        local DAddViolation = vgui.Create( "DFrame", self )
        centralFrame:ShowPopup({DAddViolation})
        DAddViolation:SetPos( ScrW()/2 - 250/2 + 50, ScrH()/2 - 350/2) 
        DAddViolation:SetSize( 250, 350 ) 
        DAddViolation:SetTitle( "Old Violation" ) 
        DAddViolation:SetVisible( true ) 
        DAddViolation:SetDraggable( true ) 
        DAddViolation:ShowCloseButton( true ) 
        DAddViolation:SetDeleteOnClose( true )
        DAddViolation:MakePopup()
        --DAddViolation:Center()

        -- TOTAL LP
        local DVioL = vgui.Create("DLabel", DAddViolation )
        DVioL:SetText( "Violation" )		
        DVioL:SetPos( 10, 25 )		
        DVioL:SetSize( 250, 30 )

        -- VIOLATION
        local DVName = vgui.Create( "DTextEntry", DAddViolation ) 
        DVName:SetPos(10, 50)
        DVName:SetSize( 230, 20)

        -- VIOLATION LEVEL
        local DLvlL = vgui.Create("DLabel", DAddViolation )
        DLvlL:SetText( "Violation Level" )		
        DLvlL:SetPos( 10, 75 )		
        DLvlL:SetSize( 250, 30 )

        local DLvl = vgui.Create("DNumberWang", DAddViolation)
        DLvl:SetPos(10, 100)
        DLvl:SetSize(100, 20)
        DLvl:SetMin(1)
        DLvl:SetMax(7)

        -- Loyalist Points
        local DLPL = vgui.Create("DLabel", DAddViolation )
        DLPL:SetText( "Loyalist Points" )		
        DLPL:SetPos( 350-210, 75 )		
        DLPL:SetSize( 250, 30 )

        local DLP = vgui.Create("DNumberWang", DAddViolation)
        DLP:SetPos(350 - 210, 100)
        DLP:SetSize(100, 20)
        DLP:SetMin(-15)
        DLP:SetMax(0)

        -- NOTES
        local DNotesL = vgui.Create("DLabel", DAddViolation )
        DNotesL:SetText( "Notes" )		
        DNotesL:SetPos( 10, 130 )		
        DNotesL:SetSize( 250, 30 )

        local DNotes = vgui.Create( "DTextEntry", DAddViolation ) 
        DNotes:SetPos(10, 155)
        DNotes:SetSize( 230, 350 - 165 )
        DNotes:SetMultiline(true)
        DNotes:SetVerticalScrollbarEnabled(true)

        DVName:SetValue(self.data.data.name)
        DLvl:SetValue(self.data.data.lvl)
        DLP:SetValue(self.data.data.lp)
        DNotes:SetValue(self.data.data.notes)

        DLvl:SetEditable(false)
        DLP:SetEditable(false)
    elseif (self.logType == "EditInfo") then
        local OldInfoFrame = vgui.Create( "DFrame", self )
        local OldCivInfo = vgui.Create("DTextEntry", OldInfoFrame)
        local NewInfoFrame = vgui.Create( "DFrame", self )
        local NewCivInfo = vgui.Create("DTextEntry", NewInfoFrame)

        centralFrame:ShowPopup({OldInfoFrame, NewInfoFrame})

        OldInfoFrame:SetTitle("Old Information")
        OldInfoFrame:SetSize(650, 180)
        OldInfoFrame:SetPos(ScrW()/2 - 650 - 50, ScrH()/2 - 180/2)
        OldCivInfo:Dock(FILL)
        OldCivInfo:SetMultiline(true)
        OldInfoFrame:MakePopup()
        OldCivInfo:SetValue(self.data.data.oldVer)
        
        NewInfoFrame:SetTitle("New Information")
        NewInfoFrame:SetSize(650, 180)
        NewInfoFrame:SetPos(ScrW()/2 + 50, ScrH()/2 - 180/2)
        NewCivInfo:Dock(FILL)
        NewCivInfo:SetMultiline(true)
        NewInfoFrame:MakePopup()
        NewCivInfo:SetValue(self.data.data.newVer)
    end
end

-- For Internal Use Only
function PANEL:SetImage(imgPath)
    self.image:SetImage(imgPath)
end

-- For Internal Use Only
function PANEL:SetType(data)
    local iconLegend = {
        ["AddAct"] = "icon16/add.png",
        ["AddVio"] = "icon16/add.png",
        ["EditAct"] = "icon16/pencil.png",
        ["EditVio"] = "icon16/pencil.png",
        ["DelAct"] = "icon16/bin.png",
        ["DelVio"] = "icon16/bin.png",
        ["EditInfo"] = "icon16/page_edit.png",
        ["MakeBOL"] = "icon16/eye.png",
        ["RemBOL"] = "icon16/eye.png",
        ["MakeWant"] = "icon16/exclamation.png",
        ["RemWant"] = "icon16/exclamation.png",
        ["MakeSus"] = "icon16/help.png",
        ["RemSus"] = "icon16/help.png",
        ["MakeHis"] = "icon16/user_red.png",
        ["RemHis"] = "icon16/user_red.png",
        ["MakeFof"] = "icon16/clock.png",
        ["RemFof"] = "icon16/clock.png",
        ["MakePhy"] = "icon16/sport_basketball.png",
        ["RemPhy"] = "icon16/sport_basketball.png",
        ["MakeMen"] = "icon16/book_open.png",
        ["RemMen"] = "icon16/book_open.png"
    }

    self.logType = data.logType
    self.data = data

    if iconLegend[self.logType] == nil then
        self:SetImage("icon16/collision_off.png")
    else
        self:SetImage(iconLegend[self.logType])
    end
    self:PopulateText()
end

-- For Internal Use Only
function PANEL:GetType()
    return self.logType
end


-- For Internal Use Only
function PANEL:SetText(text)
    self.label:SetText(text)
    self.label:SizeToContents()
end

-- For Internal Use Only
function PANEL:PopulateText()
    if (self.logType == "AddAct") then
        self:SetText(self.data.changer.." added a loyal act.")
    elseif (self.logType == "AddVio") then
        self:SetText(self.data.changer.." added a violation.")
    elseif (self.logType == "EditAct") then
        self:SetText(self.data.changer.." edited a loyal act.")
    elseif (self.logType == "EditVio") then
        self:SetText(self.data.changer.." edited a violation.")
    elseif (self.logType == "DelAct") then
        self:SetText(self.data.changer.." deleted a loyal act.")
    elseif (self.logType == "DelVio") then
        self:SetText(self.data.changer.." deleted a violation.")
    elseif (self.logType == "EditInfo") then
        self:SetText(self.data.changer.." edited the individual's information.")
    elseif (self.logType == "MakeBOL") then
        self:SetText(self.data.changer.." marked the individual as BOL.")
    elseif (self.logType == "RemBOL") then
        self:SetText(self.data.changer.." removed the individual's BOL status.")
    elseif (self.logType == "MakeWant") then
        self:SetText(self.data.changer.." marked the individual as wanted.")
    elseif (self.logType == "RemWant") then
        self:SetText(self.data.changer.." removed the individual's wanted status.")
    elseif (self.logType == "MakeSus") then
        self:SetText(self.data.changer.." marked the individual as suspicious.")
    elseif (self.logType == "RemSus") then
        self:SetText(self.data.changer.." removed the individual's suspicious status.")
    elseif (self.logType == "MakeHis") then
        self:SetText(self.data.changer.." marked the individual as having a history of violence.")
    elseif (self.logType == "RemHis") then
        self:SetText(self.data.changer.." removed the individual's history of violence status.")
    elseif (self.logType == "MakeFof") then
        self:SetText(self.data.changer.." marked the individual as a frequent offender.")
    elseif (self.logType == "RemFof") then
        self:SetText(self.data.changer.." removed the individual's frequent offender status.")
    elseif (self.logType == "MakePhy") then
        self:SetText(self.data.changer.." marked the individual as a possible 10-102P.")
    elseif (self.logType == "RemPhy") then
        self:SetText(self.data.changer.." removed the individual's possible 10-102P status.")
    elseif (self.logType == "MakeMen") then
        self:SetText(self.data.changer.." marked the individual as a possible 10-102M.")
    elseif (self.logType == "RemMen") then
        self:SetText(self.data.changer.." removed the individual's possible 10-102M status.")
    else
        self:SetText("INVALID MESSAGE")
    end
end

function PANEL:Populate(target, id, data)
    --print("T4ERSFSKMDFDKSFDKSDSA "..table.concat(target))
    self.target = target
    self:SetType(data)
    self.id = data.id
    self.timestamp:SetText(os.date("%x", data.time).. " "..os.date("%I", data.time)..":"..os.date("%M", data.time).." "..string.upper(os.date("%p", data.time)))
    self.timestamp:SizeToContents()
end

vgui.Register("DataLogEntry", PANEL)