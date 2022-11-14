DEFINE_BASECLASS("DFrame")

local PANEL = {}

AccessorFunc(PANEL, "bCommitOnClose", "CommitOnClose", FORCE_BOOL)

-- MAIN WINDOW
function PANEL:Init()
    
    --self:SetPos( ScrW()/2 - 950/2, ScrH()/2 - 750/2) 
    self:SetSize( 940 + 12, 778 + 12 ) 
    self:Center()
    self:SetTitle( "Citizen Data" ) 
    --self:ShowCloseButton( true ) 
    self:SetBackgroundBlur( true )

    self.Tabs = vgui.Create("DPropertySheet", self)
    self.Tabs:Dock(FILL)
    self.Tabs.DataEdit = vgui.Create("Panel", self.Tabs)

    self.localChanges = {}
    --[[
        
        Changes Structure
        Sample Entry for Editing a Violation

        self.localChanges[1] = {
            ["id"] = number change id,
            ["logType"] = string logType,
            ["time"] = number time,
            ["changer"] = number character id,
            ["data"] = {
                ["oldVer"] = {
                    ["name"] = string name,
                    ["lp"] = number lp given,
                    ["notes"] = string description
                },
                ["newVer"] = {
                    ["name"] = string name,
                    ["lp"] = number lp given,
                    ["notes"] = string description
                }
            }
        }
    ]]--

    self.Tabs.Logs = vgui.Create("DScrollPanel", self.Tabs)
    self.Tabs.hasLoadedLogs = false
    self.Tabs.OnActiveTabChanged = function()
        if self.Tabs.hasLoadedLogs then return end
        self.Tabs.hasLoadedLogs = true

        self:ClosePopups()

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

        for k, v in ipairs(self.committedChanges) do
            local dataPoint = self.committedChanges[#self.committedChanges-k+1]
            local entry = vgui.Create("DataLogEntry", self.Tabs.Logs)
            entry:Dock(TOP)
            entry:DockMargin(5, 5, 5, 5)
            entry:Populate(self.target, k, {
                ["logType"] = dataPoint.logType,
                ["changer"] = ix.char.loaded[dataPoint.changer]:GetName(),
                ["time"] = dataPoint.time,
                ["id"] = k,
                ["data"] = dataPoint.data
            })
            entry:Dock(TOP)
            entry:DockMargin(5, 5, 5, 5)
        end

    /*
        for k, v in pairs(iconLegend) do
            local entry = vgui.Create("DataLogEntry", self.Tabs.Logs)
            entry:Populate(self.target, k, {["changer"] = "CCA.C17-UNION.i5.27015", ["time"] = os.time(), ["id"] = math.random(1,100)})
            entry:Dock(TOP)
            entry:DockMargin(5, 5, 5, 5)
        end
        */  
    end

    self.Tabs:AddSheet("Data Editor", self.Tabs.DataEdit, "icon16/application_view_list.png")
    self.Tabs:AddSheet("Logs", self.Tabs.Logs, "icon16/chart_organisation.png")

    -- DATA EDITOR 
    do
        -- LOYAL ACTS TITLE
        do
            self.DTitleA = vgui.Create("DLabel", self.Tabs.DataEdit )
            self.DTitleA:SetText( "Loyal Acts" )
            self.DTitleA:SetFont("DermaLarge")	
            self.DTitleA:SetPos( 10, 584-110-260 )		
            self.DTitleA:SetSize( 250, 30 )	
        end
        
        -- LOYAL ACTS DLISTVIEW
        do
            self.DLoyal = vgui.Create( "DListView", self.Tabs.DataEdit )
            self.DLoyal:SetPos(10, 619-110-260)
            self.DLoyal:SetSize(650, 200)
            self.DLoyal:SetMultiSelect( false )

            self.DAct = self.DLoyal:AddColumn( "Loyal Act", 1 )
            self.DLP = self.DLoyal:AddColumn( "LP Given", 2 )
            self.DNotesA = self.DLoyal:AddColumn( "Notes", 3 )
        end

        -- VIOLATIONS LABEL
        do
            self.DTitleV = vgui.Create("DLabel", self.Tabs.DataEdit )
            self.DTitleV:SetText( "Violations" )	
            self.DTitleV:SetFont("DermaLarge")
            self.DTitleV:SetPos( 10, 584-110 )		
            self.DTitleV:SetSize( 250, 30 )
        end

        -- VIOLATIONS DLISTVIEW
        do
            self.DViolations = vgui.Create( "DListView", self.Tabs.DataEdit )
            self.DViolations:SetPos(10, 619-110)
            self.DViolations:SetSize(650, 200)
            self.DViolations:SetMultiSelect( false )

            self.DRecV = self.DViolations:AddColumn( "Violation", 1 )
            self.DLvlV = self.DViolations:AddColumn( "Violation Level", 2 )
            self.DPP = self.DViolations:AddColumn( "LP Given", 3 )
            self.DNotesV = self.DViolations:AddColumn( "Notes", 4 )
        end

        -- TOTAL LP
        do
            self.DSumLP = vgui.Create("DLabel", self.Tabs.DataEdit )
            self.DSumLP:SetText( "Total LP: " )		
            self.DSumLP:SetPos( 670, 11+10 )		
            self.DSumLP:SetSize( 250, 30 )
        end

        -- TOTAL POSITIVE LP
        do
            self.DSumA = vgui.Create("DLabel", self.Tabs.DataEdit )
            self.DSumA:SetText( "Reward LP Sum: " )		
            self.DSumA:SetPos( 670, 459-160-10-20-10)		
            self.DSumA:SetSize( 250, 30 )
        end	

        -- TOTAL NEGATIVE LP
        do
            self.DSumV = vgui.Create("DLabel", self.Tabs.DataEdit )
            self.DSumV:SetText( "Violation LP Sum: " )		
            self.DSumV:SetPos( 670, 559-40 )		
            self.DSumV:SetSize( 250, 30 )
        end

        -- NOTES
        do
            self.DCivInfo = vgui.Create( "DTextEntry", self.Tabs.DataEdit ) 
            self.DCivInfo:SetPos(10, 11)
            self.DCivInfo:SetSize( 650, 180 )
            self.DCivInfo:SetMultiline(true)
            self.DCivInfo:SetVerticalScrollbarEnabled(true)
        end

        -- CHECKBOXES
        do
            self.DWant = vgui.Create( "DCheckBoxLabel", self.Tabs.DataEdit )
            self.DWant:SetPos(670, 4+52)
            self.DWant:SetText("Wanted")
            self.DWant.OnChange = function(checkbox, checked)
                if checked then
                    self.localChanges[#self.localChanges+1] = {
                        ["id"] = #self.committedChanges+#self.localChanges+1,
                        ["logType"] = "MakeWant",
                        ["time"] = os.time(),
                        ["changer"] = LocalPlayer():GetCharacter():GetID(), 
                        ["data"] = nil
                    }
                else
                    self.localChanges[#self.localChanges+1] = {
                        ["id"] = #self.committedChanges+#self.localChanges+1,
                        ["logType"] = "RemWant",
                        ["time"] = os.time(),
                        ["changer"] = LocalPlayer():GetCharacter():GetID(), 
                        ["data"] = nil
                    }
                end
            end

            self.DBOL = vgui.Create( "DCheckBoxLabel", self.Tabs.DataEdit )
            self.DBOL:SetPos(670, 4+72)
            self.DBOL:SetText("BOL")
            self.DBOL.OnChange = function(checkbox, checked)
                if checked then
                    self.localChanges[#self.localChanges+1] = {
                        ["id"] = #self.committedChanges+#self.localChanges+1,
                        ["logType"] = "MakeBOL",
                        ["time"] = os.time(),
                        ["changer"] = LocalPlayer():GetCharacter():GetID(), 
                        ["data"] = nil
                    }
                else
                    self.localChanges[#self.localChanges+1] = {
                        ["id"] = #self.committedChanges+#self.localChanges+1,
                        ["logType"] = "RemBOL",
                        ["time"] = os.time(),
                        ["changer"] = LocalPlayer():GetCharacter():GetID(), 
                        ["data"] = nil
                    }
                end
            end

            self.DSus = vgui.Create( "DCheckBoxLabel", self.Tabs.DataEdit )
            self.DSus:SetPos(670, 4+92)
            self.DSus:SetText("Suspicious")
            self.DSus.OnChange = function(checkbox, checked)
                if checked then
                    self.localChanges[#self.localChanges+1] = {
                        ["id"] = #self.committedChanges+#self.localChanges+1,
                        ["logType"] = "MakeSus",
                        ["time"] = os.time(),
                        ["changer"] = LocalPlayer():GetCharacter():GetID(), 
                        ["data"] = nil
                    }
                else
                    self.localChanges[#self.localChanges+1] = {
                        ["id"] = #self.committedChanges+#self.localChanges+1,
                        ["logType"] = "RemSus",
                        ["time"] = os.time(),
                        ["changer"] = LocalPlayer():GetCharacter():GetID(), 
                        ["data"] = nil
                    }
                end
            end

            self.DHVio = vgui.Create( "DCheckBoxLabel", self.Tabs.DataEdit)
            self.DHVio:SetPos(670, 4+112)
            self.DHVio:SetText("History of Violence")
            self.DHVio.OnChange = function(checkbox, checked)
                if checked then
                    self.localChanges[#self.localChanges+1] = {
                        ["id"] = #self.committedChanges+#self.localChanges+1,
                        ["logType"] = "MakeHis",
                        ["time"] = os.time(),
                        ["changer"] = LocalPlayer():GetCharacter():GetID(), 
                        ["data"] = nil
                    }
                else
                    self.localChanges[#self.localChanges+1] = {
                        ["id"] = #self.committedChanges+#self.localChanges+1,
                        ["logType"] = "RemHis",
                        ["time"] = os.time(),
                        ["changer"] = LocalPlayer():GetCharacter():GetID(), 
                        ["data"] = nil
                    }
                end
            end

            self.DFOff = vgui.Create( "DCheckBoxLabel", self.Tabs.DataEdit )
            self.DFOff:SetPos(670, 4+132)
            self.DFOff:SetText("Frequent Offender")
            self.DFOff.OnChange = function(checkbox, checked)
                if checked then
                    self.localChanges[#self.localChanges+1] = {
                        ["id"] = #self.committedChanges+#self.localChanges+1,
                        ["logType"] = "MakeFof",
                        ["time"] = os.time(),
                        ["changer"] = LocalPlayer():GetCharacter():GetID(), 
                        ["data"] = nil
                    }
                else
                    self.localChanges[#self.localChanges+1] = {
                        ["id"] = #self.committedChanges+#self.localChanges+1,
                        ["logType"] = "RemFof",
                        ["time"] = os.time(),
                        ["changer"] = LocalPlayer():GetCharacter():GetID(), 
                        ["data"] = nil
                    }
                end
            end

            self.DMUnfit = vgui.Create( "DCheckBoxLabel", self.Tabs.DataEdit )
            self.DMUnfit:SetPos(670, 4+152)
            self.DMUnfit:SetText("Possible 10-102M")
            self.DMUnfit.OnChange = function(checkbox, checked)
                if checked then
                    self.localChanges[#self.localChanges+1] = {
                        ["id"] = #self.committedChanges+#self.localChanges+1,
                        ["logType"] = "MakeMen",
                        ["time"] = os.time(),
                        ["changer"] = LocalPlayer():GetCharacter():GetID(), 
                        ["data"] = nil
                    }
                else
                    self.localChanges[#self.localChanges+1] = {
                        ["id"] = #self.committedChanges+#self.localChanges+1,
                        ["logType"] = "RemMen",
                        ["time"] = os.time(),
                        ["changer"] = LocalPlayer():GetCharacter():GetID(), 
                        ["data"] = nil
                    }
                end
            end

            self.DPUnfit = vgui.Create( "DCheckBoxLabel", self.Tabs.DataEdit )
            self.DPUnfit:SetPos(670, 4+172)
            self.DPUnfit:SetText("Possible 10-102P")
            self.DPUnfit.OnChange = function(checkbox, checked)
                if checked then
                    self.localChanges[#self.localChanges+1] = {
                        ["id"] = #self.committedChanges+#self.localChanges+1,
                        ["logType"] = "MakePhy",
                        ["time"] = os.time(),
                        ["changer"] = LocalPlayer():GetCharacter():GetID(), 
                        ["data"] = nil
                    }
                else
                    self.localChanges[#self.localChanges+1] = {
                        ["id"] = #self.committedChanges+#self.localChanges+1,
                        ["logType"] = "RemPhy",
                        ["time"] = os.time(),
                        ["changer"] = LocalPlayer():GetCharacter():GetID(), 
                        ["data"] = nil
                    }
                end
            end

        end

        self.DAddA = vgui.Create("DButton", self.Tabs.DataEdit )
        self.DAddA:SetText( "Add Loyal Act" )		
        self.DAddA:SetPos( 670, 459-160 )				
        self.DAddA:SetSize( 250, 30 )
        self.DAddA.DoClick = function()

            local DAddLoyalAct = vgui.Create( "DFrame", self.Tabs.DataEdit )
            self:ShowPopup({DAddLoyalAct})
            DAddLoyalAct:SetPos( ScrW()/2 - 250/2, ScrH()/2 - 385/2) 
            DAddLoyalAct:SetSize( 250, 385 ) 
            DAddLoyalAct:SetTitle( "Add Loyal Act" ) 
            DAddLoyalAct:SetVisible( true ) 
            DAddLoyalAct:SetDraggable( true ) 
            DAddLoyalAct:ShowCloseButton( true ) 
            DAddLoyalAct:SetDeleteOnClose( true )
            DAddLoyalAct:MakePopup()

            -- TOTAL LP
            local DActL = vgui.Create("DLabel", DAddLoyalAct )
            DActL:SetText( "Loyal Act" )		
            DActL:SetPos( 10, 25 )		
            DActL:SetSize( 250, 30 )

            -- VIOLATION
            local DAct = vgui.Create( "DTextEntry", DAddLoyalAct ) 
            DAct:SetPos(10, 50)
            DAct:SetSize(230, 20)

            -- LOYALITY POINTS
            local DLPL = vgui.Create("DLabel", DAddLoyalAct )
            DLPL:SetText( "Loyalist Points" )		
            DLPL:SetPos( 10, 75 )	
            DLPL:SetSize( 250, 30 )

            local DLP = vgui.Create("DNumberWang", DAddLoyalAct )
            DLP:SetPos(10, 100)
            DLP:SetSize(100, 20)
            DLP:SetMin(0)
            DLP:SetMax(15)

            -- NOTES
            local DNotesL = vgui.Create("DLabel", DAddLoyalAct )
            DNotesL:SetText( "Notes" )		
            DNotesL:SetPos( 10, 130 )		
            DNotesL:SetSize( 250, 30 )


            local DNotes = vgui.Create( "DTextEntry", DAddLoyalAct ) 
            DNotes:SetPos(10, 155)
            DNotes:SetSize( 230, 350 - 165 )
            DNotes:SetMultiline(true)
            DNotes:SetVerticalScrollbarEnabled(true)

            -- SUBMIT BUTTON
            local DSubmit = vgui.Create("DButton", DAddLoyalAct )
            DSubmit:SetText( "Submit" )		
            DSubmit:SetPos( 250/2 - 85/2, 390-40 )			
            DSubmit:SetSize( 85, 25 )
            DSubmit.DoClick = function()
                self.localChanges[#self.localChanges+1] = {
                    ["id"] = #self.committedChanges+#self.localChanges+1,
                    ["logType"] = "AddAct",
                    ["time"] = os.time(),
                    ["changer"] = LocalPlayer():GetCharacter():GetID(), 
                    ["data"] = {
                        ["name"] = DAct:GetValue(),
                        ["lp"] = DLP:GetValue(),
                        ["notes"] = DNotes:GetValue()
                    }
                }
                self.DLoyal:AddLine(DAct:GetValue(), DLP:GetValue(), DNotes:GetValue())

                local ASumNum = 0
                local VSumNum = 0
                local SumLPNUM = 0

                for k, v in pairs(self.DLoyal:GetLines()) do

                    ASumNum = ASumNum + tonumber(v:GetColumnText(2))
                
                end

                for k, v in pairs(self.DViolations:GetLines()) do

                    VSumNum = VSumNum + tonumber(v:GetColumnText(3))
                
                end

                self.DSumLP:SetText("Total LP: "..tostring(ASumNum) - tostring(VSumNum))
                self.DSumA:SetText("Reward LP Sum: "..tostring(ASumNum))
                self.DSumV:SetText("Violation LP Sum: "..tostring(VSumNum))

                self:ClosePopups()
                DAddLoyalAct:Close()
            end

        end

        self.DEditA = vgui.Create("DButton", self.Tabs.DataEdit )
        self.DEditA:SetText( "Edit Loyal Act" )		
        self.DEditA:SetPos( 670, 499-160 )			
        self.DEditA:SetSize( 250, 30 )
        self.DEditA.DoClick = function()
            local numberID, lineObj = self.DLoyal:GetSelectedLine()

            if not (lineObj == nil) then

                local DAddLoyalAct = vgui.Create( "DFrame", self.Tabs.DataEdit )
                self:ShowPopup({DAddLoyalAct})
                DAddLoyalAct:SetPos( ScrW()/2 - 250/2, ScrH()/2 - 385/2) 
                DAddLoyalAct:SetSize( 250, 385 ) 
                DAddLoyalAct:SetTitle( "Edit Loyal Act" ) 
                DAddLoyalAct:SetVisible( true ) 
                DAddLoyalAct:SetDraggable( true ) 
                DAddLoyalAct:ShowCloseButton( true ) 
                DAddLoyalAct:SetDeleteOnClose( true )
                DAddLoyalAct.OnClose = function()
                    self.popups = nil
                end

                DAddLoyalAct:MakePopup()

                -- TOTAL LP
                local DActL = vgui.Create("DLabel", DAddLoyalAct )
                DActL:SetText( "Loyal Act" )		
                DActL:SetPos( 10, 25 )		
                DActL:SetSize( 250, 30 )


                -- VIOLATION
                local DAct = vgui.Create( "DTextEntry", DAddLoyalAct ) 
                DAct:SetPos(10, 50)
                DAct:SetSize( 230, 20)

                -- LOYALITY POINTS
                local DLPL = vgui.Create("DLabel", DAddLoyalAct )
                DLPL:SetText( "Loyalist Points" )		
                DLPL:SetPos( 10, 75 )		
                DLPL:SetSize( 250, 30 )

                local DLP = vgui.Create("DNumberWang", DAddLoyalAct)
                DLP:SetPos(10, 100)
                DLP:SetSize(100, 20)
                DLP:SetMin(0)
                DLP:SetMax(15)

                -- NOTES
                local DNotesL = vgui.Create("DLabel", DAddLoyalAct )
                DNotesL:SetText( "Notes" )		
                DNotesL:SetPos( 10, 130 )		
                DNotesL:SetSize( 250, 30 )


                local DNotes = vgui.Create( "DTextEntry", DAddLoyalAct ) 
                DNotes:SetPos(10, 155)
                DNotes:SetSize( 230, 350 - 165 )
                DNotes:SetMultiline(true)
                DNotes:SetVerticalScrollbarEnabled(true)

                -- SUBMIT BUTTON
                local DSubmit = vgui.Create("DButton", DAddLoyalAct )
                DSubmit:SetText( "Submit" )		
                DSubmit:SetPos( 250/2 - 85/2, 390-40 )			
                DSubmit:SetSize( 85, 25 )
                DSubmit.DoClick = function()
                    self.localChanges[#self.localChanges+1] = {
                        ["id"] = #self.committedChanges+#self.localChanges+1,
                        ["logType"] = "EditAct",
                        ["time"] = os.time(),
                        ["changer"] = LocalPlayer():GetCharacter():GetID(), 
                        ["data"] = {
                            ["newVer"] = {
                                ["name"] = DAct:GetValue(),
                                ["lp"] = DLP:GetValue(),
                                ["notes"] = DNotes:GetValue()
                            },
                            ["oldVer"] = {
                                ["name"] = self.DLoyal:GetLine(numberID):GetColumnText(1),
                                ["lp"] = self.DLoyal:GetLine(numberID):GetColumnText(2),
                                ["notes"] = self.DLoyal:GetLine(numberID):GetColumnText(3)
                            }
                        }
                    }

                    self.DLoyal:GetLine(numberID):SetColumnText(1, DAct:GetValue())
                    self.DLoyal:GetLine(numberID):SetColumnText(2, DLP:GetValue())
                    self.DLoyal:GetLine(numberID):SetColumnText(3, DNotes:GetValue())

                    local ASumNum = 0
                    local VSumNum = 0
                    local SumLPNUM = 0

                    for k, v in pairs(self.DLoyal:GetLines()) do

                        ASumNum = ASumNum + tonumber(v:GetColumnText(2))
                    
                    end

                    for k, v in pairs(self.DViolations:GetLines()) do

                        VSumNum = VSumNum + tonumber(v:GetColumnText(3))
                    
                    end

                    self.DSumLP:SetText("Total LP: "..tostring(ASumNum) - tostring(VSumNum))
                    self.DSumA:SetText("Reward LP Sum: "..tostring(ASumNum))
                    self.DSumV:SetText("Violation LP Sum: "..tostring(VSumNum))

                    self:ClosePopups()
                    DAddLoyalAct:Close()
                end

                DAct:SetValue(lineObj:GetColumnText(1))
                DLP:SetValue(lineObj:GetColumnText(2))
                DNotes:SetValue(lineObj:GetColumnText(3))

            end
        
        end

        self.DViewA = vgui.Create("DButton", self.Tabs.DataEdit )
        self.DViewA:SetText( "View Loyal Act" )		
        self.DViewA:SetPos( 670, 539-160)			
        self.DViewA:SetSize( 250, 30 )
        
        self.DViewA.DoClick = function()
        
            local numberID, lineObj = self.DLoyal:GetSelectedLine()

            if not (lineObj == nil) then

                local DViewLoyalAct = vgui.Create( "DFrame", self.Tabs.DataEdit )
                self:ShowPopup({DViewLoyalAct})
                DViewLoyalAct:SetPos( ScrW()/2 - 250/2, ScrH()/2 - 350/2) 
                DViewLoyalAct:SetSize( 250, 350 ) 
                DViewLoyalAct:SetTitle( "View Loyal Act" ) 
                DViewLoyalAct:SetVisible( true ) 
                DViewLoyalAct:SetDraggable( true ) 
                DViewLoyalAct:ShowCloseButton( true ) 
                DViewLoyalAct:SetDeleteOnClose( true )
                DViewLoyalAct.OnClose = function()
                    self.popups = nil
                end
                DViewLoyalAct:MakePopup()

                -- TOTAL LP
                local DActL = vgui.Create("DLabel", DViewLoyalAct )
                DActL:SetText( "Loyal Act" )		
                DActL:SetPos( 10, 25 )		
                DActL:SetSize( 250, 30 )


                -- LOYAL ACTS
                local DAct = vgui.Create( "DTextEntry", DViewLoyalAct ) 
                DAct:SetPos(10, 50)
                DAct:SetSize( 230, 20)


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

                DAct:SetValue(lineObj:GetColumnText(1))
                DLP:SetValue(lineObj:GetColumnText(2))
                DNotes:SetValue(lineObj:GetColumnText(3))
                DAct:SetEditable(false)
                DLP:SetEditable(false)

            end
        
        end

        self.DNixA = vgui.Create("DButton", self.Tabs.DataEdit )
        self.DNixA:SetText( "Remove Loyal Act" )		
        self.DNixA:SetPos( 670, 579-160 )			
        self.DNixA:SetSize( 250, 30 )
        self.DNixA.DoClick = function()

            local numberID, lineObj = self.DLoyal:GetSelectedLine()

            if not (lineObj == nil) then
                
                local DWarning = vgui.Create( "DFrame", self.Tabs.DataEdit )
                self:ShowPopup({DWarning})
                DWarning:SetPos( ScrW()/2 - 350/2, ScrH()/2 - 125/2) 
                DWarning:SetSize( 350, 125 ) 
                DWarning:SetTitle( "Warning" ) 
                DWarning:SetVisible( true ) 
                DWarning:SetDraggable( true ) 
                DWarning:ShowCloseButton( true ) 
                DWarning:SetDeleteOnClose( true )
                DWarning.OnClose = function()
                    self.popups = nil
                end
                DWarning:MakePopup()

                local DLineOne = vgui.Create("DLabel", DWarning )
                DLineOne:SetText( "You are about to permanently delete a record." )	
                DLineOne:SetFont( "DermaDefaultBold" )			
                DLineOne:SetPos( 350/4 - 45,  25 )		
                DLineOne:SetSize( 450, 30 )

                local DLineTwo = vgui.Create("DLabel", DWarning )
                DLineTwo:SetText( "Do you wish to proceed?" )	
                DLineTwo:SetFont( "DermaDefaultBold" )		
                DLineTwo:SetPos( 350/2 - 65, 45 )
                DLineTwo:SetSize( 250, 30 )



                local DYes = vgui.Create("DButton", DWarning )
                DYes:SetText( "Yes" )	
                DYes:SetPos( 10, 115-25 )		
                DYes:SetSize( 85, 25 )
                DYes.DoClick = function()
                    self.localChanges[#self.localChanges+1] = {
                        ["id"] = #self.committedChanges+#self.localChanges+1,
                        ["logType"] = "DelAct",
                        ["time"] = os.time(),
                        ["changer"] = LocalPlayer():GetCharacter():GetID(), 
                        ["data"] = {
                            ["name"] = self.DLoyal:GetLine(numberID):GetColumnText(1),
                            ["lp"] = self.DLoyal:GetLine(numberID):GetColumnText(2),
                            ["notes"] = self.DLoyal:GetLine(numberID):GetColumnText(3)
                        }
                    }
                    self.DLoyal:RemoveLine(numberID)
                    DWarning:Close()
                end

                local DNo = vgui.Create("DButton", DWarning )
                DNo:SetText( "No" )		
                DNo:SetFont("DermaDefaultBold")		
                DNo:SetPos( 85+10+10, 115-25 )			
                DNo:SetSize( 350-85-10*3, 25 )
                DNo.DoClick = function()
                    DWarning:Close()
                end

            end
        
        end

        self.DRecV:SetWidth(150)
        self.DLvlV:SetWidth(90)
        self.DPP:SetWidth(80)

        self.DAddV = vgui.Create("DButton", self.Tabs.DataEdit )
        self.DAddV:SetText( "Add Violation" )		
        self.DAddV:SetPos( 670, 559 )
        self.DAddV:SetSize( 250, 30 )
        self.DAddV.DoClick = function()

            local DAddViolation = vgui.Create( "DFrame", self.Tabs.DataEdit )
            self:ShowPopup({DAddViolation})
            DAddViolation:SetPos( ScrW()/2 - 250/2, ScrH()/2 - 385/2) 
            DAddViolation:SetSize( 250, 385 ) 
            DAddViolation:SetTitle( "Add Violation" ) 
            DAddViolation:SetVisible( true ) 
            DAddViolation:SetDraggable( true ) 
            DAddViolation:ShowCloseButton( true ) 
            DAddViolation:SetDeleteOnClose( true )
            DAddViolation.OnClose = function()
                self.popups = nil
            end
            DAddViolation:MakePopup()

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

            -- SUBMIT BUTTON
            local DSubmit = vgui.Create("DButton", DAddViolation )
            DSubmit:SetText( "Submit" )		
            DSubmit:SetPos( 250/2 - 85/2, 390-40 )			
            DSubmit:SetSize( 85, 25 )
            DSubmit.DoClick = function()
                self.localChanges[#self.localChanges+1] = {
                    ["id"] = #self.committedChanges+#self.localChanges+1,
                    ["logType"] = "AddVio",
                    ["time"] = os.time(),
                    ["changer"] = LocalPlayer():GetCharacter():GetID(), 
                    ["data"] = {
                        ["name"] = DVName:GetValue(),
                        ["lvl"] = DLvl:GetValue(),
                        ["lp"] = DLP:GetValue(),
                        ["notes"] = DNotes:GetValue()
                    }
                }
                self.DViolations:AddLine(DVName:GetValue(), DLvl:GetValue(), DLP:GetValue(), DNotes:GetValue())

                local ASumNum = 0
                local VSumNum = 0
                local SumLPNUM = 0

                for k, v in pairs(self.DLoyal:GetLines()) do

                    ASumNum = ASumNum + tonumber(v:GetColumnText(2))
                
                end

                for k, v in pairs(self.DViolations:GetLines()) do

                    VSumNum = VSumNum + tonumber(v:GetColumnText(3))
                
                end

                self.DSumLP:SetText("Total LP: "..tostring(ASumNum) - tostring(VSumNum))
                self.DSumA:SetText("Reward LP Sum: "..tostring(ASumNum))
                self.DSumV:SetText("Violation LP Sum: "..tostring(VSumNum))

                DAddViolation:Close()
            end
            
        
        end

        self.DEditV = vgui.Create("DButton", self.Tabs.DataEdit )
        self.DEditV:SetText( "Edit Violation" )		
        self.DEditV:SetPos( 670, 599 )			
        self.DEditV:SetSize( 250, 30 )
        self.DEditV.DoClick = function() 
        
            local numberID, lineObj = self.DViolations:GetSelectedLine()

            if not (lineObj == nil) then

                local DAddViolation = vgui.Create( "DFrame", self.Tabs.DataEdit )
                self:ShowPopup({DAddViolation})
                DAddViolation:SetPos( ScrW()/2 - 250/2, ScrH()/2 - 385/2) 
                DAddViolation:SetSize( 250, 385 ) 
                DAddViolation:SetTitle( "Edit Violation" ) 
                DAddViolation:SetVisible( true ) 
                DAddViolation:SetDraggable( true ) 
                DAddViolation:ShowCloseButton( true ) 
                DAddViolation:SetDeleteOnClose( true )
                DAddViolation.OnClose = function()
                    self.popups = nil
                end
                DAddViolation:MakePopup()

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

                -- SUBMIT BUTTON
                local DSubmit = vgui.Create("DButton", DAddViolation )
                DSubmit:SetText( "Submit" )		
                DSubmit:SetPos( 250/2 - 85/2, 390-40 )			
                DSubmit:SetSize( 85, 25 )
                DSubmit.DoClick = function()
                    self.localChanges[#self.localChanges+1] = {
                        ["id"] = #self.committedChanges+#self.localChanges+1,
                        ["logType"] = "EditVio",
                        ["time"] = os.time(),
                        ["changer"] = LocalPlayer():GetCharacter():GetID(), 
                        ["data"] = {
                            ["newVer"] = {
                                ["name"] = DVName:GetValue(),
                                ["lvl"] = DLvl:GetValue(),
                                ["lp"] = DLP:GetValue(),
                                ["notes"] = DNotes:GetValue()
                            },
                            ["oldVer"] = {
                                ["name"] = self.DViolations:GetLine(numberID):GetColumnText(1),
                                ["lvl"] = self.DViolations:GetLine(numberID):GetColumnText(2),
                                ["lp"] = self.DViolations:GetLine(numberID):GetColumnText(3),
                                ["notes"] = self.DViolations:GetLine(numberID):GetColumnText(3)
                            }
                        }
                    }

                    self.DViolations:GetLine(numberID):SetColumnText(1, DVName:GetValue())
                    self.DViolations:GetLine(numberID):SetColumnText(2, DLvl:GetValue())
                    self.DViolations:GetLine(numberID):SetColumnText(3, DLP:GetValue())
                    self.DViolations:GetLine(numberID):SetColumnText(4, DNotes:GetValue())

                    local ASumNum = 0
                    local VSumNum = 0
                    local SumLPNUM = 0

                    for k, v in pairs(self.DLoyal:GetLines()) do

                        ASumNum = ASumNum + tonumber(v:GetColumnText(2))
                    
                    end

                    for k, v in pairs(self.DViolations:GetLines()) do

                        VSumNum = VSumNum + tonumber(v:GetColumnText(3))
                    
                    end

                    self.DSumLP:SetText("Total LP: "..tostring(ASumNum) - tostring(VSumNum))
                    self.DSumA:SetText("Reward LP Sum: "..tostring(ASumNum))
                    self.DSumV:SetText("Violation LP Sum: "..tostring(VSumNum))

                    DAddViolation:Close()
                end

                DVName:SetValue(lineObj:GetColumnText(1))
                DLvl:SetValue(lineObj:GetColumnText(2))
                DLP:SetValue(lineObj:GetColumnText(3))
                DNotes:SetValue(lineObj:GetColumnText(4))


            end
        
        end

        self.DViewV = vgui.Create("DButton", self.Tabs.DataEdit )
        self.DViewV:SetText( "View Violation" )		
        self.DViewV:SetPos( 670, 639 )			
        self.DViewV:SetSize( 250, 30 )
        self.DViewV.DoClick = function()
        

            local numberID, lineObj = self.DViolations:GetSelectedLine()

            if not (lineObj == nil) then

                local DAddViolation = vgui.Create( "DFrame", self.Tabs.DataEdit )
                self:ShowPopup({DAddViolation})
                DAddViolation:SetPos( ScrW()/2 - 250/2, ScrH()/2 - 350/2) 
                DAddViolation:SetSize( 250, 350 ) 
                DAddViolation:SetTitle( "View Violation" ) 
                DAddViolation:SetVisible( true ) 
                DAddViolation:SetDraggable( true ) 
                DAddViolation:ShowCloseButton( true ) 
                DAddViolation:SetDeleteOnClose( true )
                DAddViolation.OnClose = function()
                    self.popups = nil
                end
                DAddViolation:MakePopup()

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
                
                DVName:SetValue(lineObj:GetColumnText(1))
                DLvl:SetValue(lineObj:GetColumnText(2))
                DLP:SetValue(lineObj:GetColumnText(3))
                DNotes:SetValue(lineObj:GetColumnText(4))
                DLvl:SetEditable(false)
                DLP:SetEditable(false)

            end
        
        end

        self.DNixV = vgui.Create("DButton", self.Tabs.DataEdit )
        self.DNixV:SetText( "Remove Violation" )		
        self.DNixV:SetPos( 670, 679 )			
        self.DNixV:SetSize( 250, 30 )
        self.DNixV.DoClick = function()

            local numberID, lineObj = self.DViolations:GetSelectedLine()

            if (lineObj != nil) then
                
                local DWarning = vgui.Create( "DFrame" , self.Tabs.DataEdit )
                self:ShowPopup({DWarning})
                DWarning:SetPos( ScrW()/2 - 350/2, ScrH()/2 - 125/2) 
                DWarning:SetSize( 350, 125 ) 
                DWarning:SetTitle( "Warning" ) 
                DWarning:SetVisible( true ) 
                DWarning:SetDraggable( true ) 
                DWarning:ShowCloseButton( true ) 
                DWarning:SetDeleteOnClose( true )
                DWarning.OnClose = function()
                    self.popups = nil
                end
                DWarning:MakePopup()

                local DLineOne = vgui.Create("DLabel", DWarning )
                DLineOne:SetText( "You are about to permanently delete a record." )	
                DLineOne:SetFont( "DermaDefaultBold" )			
                DLineOne:SetPos( 350/4 - 45,  25 )		
                DLineOne:SetSize( 450, 30 )

                local DLineTwo = vgui.Create("DLabel", DWarning )
                DLineTwo:SetText( "Do you wish to proceed?" )	
                DLineTwo:SetFont( "DermaDefaultBold" )		
                DLineTwo:SetPos( 350/2 - 65, 45 )
                DLineTwo:SetSize( 250, 30 )

                local DYes = vgui.Create("DButton", DWarning )
                DYes:SetText( "Yes" )	
                DYes:SetPos( 10, 115-25 )		
                DYes:SetSize( 85, 25 )
                DYes.DoClick = function()
                    self.localChanges[#self.localChanges+1] = {
                        ["id"] = #self.committedChanges+#self.localChanges+1,
                        ["logType"] = "DelVio",
                        ["time"] = os.time(),
                        ["changer"] = LocalPlayer():GetCharacter():GetID(), 
                        ["data"] = {
                            ["name"] = self.DViolations:GetLine(numberID):GetColumnText(1),
                            ["lvl"] = self.DViolations:GetLine(numberID):GetColumnText(2),
                            ["lp"] = self.DViolations:GetLine(numberID):GetColumnText(3),
                            ["notes"] = self.DViolations:GetLine(numberID):GetColumnText(4)
                        }
                    }
                    self.DViolations:RemoveLine(numberID)
                    DWarning:Close()
                end

                local DNo = vgui.Create("DButton", DWarning )
                DNo:SetText( "No" )		
                DNo:SetFont("DermaDefaultBold")		
                DNo:SetPos( 85+10+10, 115-25 )			
                DNo:SetSize( 350-85-10*3, 25 )
                DNo.DoClick = function()
                    DWarning:Close()
                end

            end
        
        end

        -- UPDATING LP COUNT WHEN RECORDS UPDATED
        function updateLP()    

            local ASumNum = 0
            local VSumNum = 0
            local SumLPNUM = 0

            for k, v in pairs(self.DLoyal:GetLines()) do

                ASumNum = ASumNum + tonumber(v:GetColumnText(2))
            
            end

            for k, v in pairs(self.DViolations:GetLines()) do

                VSumNum = VSumNum + tonumber(v:GetColumnText(3))
            
            end

            self.DSumLP:SetText("Total LP: "..tostring(ASumNum - VSumNum))
            self.DSumA:SetText("Reward LP Sum: "..tostring(ASumNum))
            self.DSumV:SetText("Violation LP Sum: "..tostring(VSumNum))
        
        end
        
        -- INITIAL LP CALCULATIONS
        do
            local ASumNum = 0
            local VSumNum = 0
            local SumLPNUM = 0

            for k, v in pairs(self.DLoyal:GetLines()) do

                ASumNum = ASumNum + tonumber(v:GetColumnText(2))
                
            end

            for k, v in pairs(self.DViolations:GetLines()) do

                VSumNum = VSumNum + tonumber(v:GetColumnText(3))
                
            end

            self.DSumLP:SetText("Total LP: "..tostring(ASumNum) - tostring(VSumNum))
            self.DSumA:SetText("Reward LP Sum: "..tostring(ASumNum))
            self.DSumV:SetText("Violation LP Sum: "..tostring(VSumNum))
        end
    end

    self:MakePopup()
end

function PANEL:Populate(target, data)
    self.target = target
    --LocalPlayer():ChatPrint(target)
    --LocalPlayer():ChatPrint(self.target)
    self.data = data

    self.committedChanges = data.changes
    if self.committedChanges == nil then
        self.committedChanges = {}
    end

    self:SetTitle(target:GetCharacter():GetName().."'s Data, #"..data.cid)    

    self.DCivInfo:SetValue(data.textData)

    self.DWant:SetChecked(data.checkboxes.wanted)
    self.DBOL:SetChecked(data.checkboxes.bol)
    self.DSus:SetChecked(data.checkboxes.sus)
    self.DHVio:SetChecked(data.checkboxes.violencehist)
    self.DFOff:SetChecked(data.checkboxes.freqoff)
    self.DMUnfit:SetChecked(data.checkboxes.poss104m)
    self.DPUnfit:SetChecked(data.checkboxes.poss104p)

    if (data.loyalacts == nil) then
        data.loyalacts = {}
    end

    if (data.violations == nil) then
        data.violations = {}
    end
    
    for k, v in ipairs(data.loyalacts) do 
        if (v.vioname == nil) then
            self.DLoyal:AddLine(v.actname, v.lp, v.notes)
        end
    end

    for k, v in ipairs(data.violations) do 
        if (v.actname == nil) then
            self.DViolations:AddLine(v.vioname, v.lvl, v.lp, v.notes)
        end
    end
    
    updateLP()
end

function PANEL:OnClose()

    local emptyTbl = {}

    local savingData = {
        ["loyalacts"] = emptyTbl,
        ["violations"] = emptyTbl,
        ["textData"] = self.DCivInfo:GetValue(),
        ["checkboxes"] = {
            ["wanted"] = self.DWant:GetChecked(),
            ["bol"] = self.DBOL:GetChecked(),
            ["sus"] = self.DSus:GetChecked(),
            ["violencehist"] = self.DHVio:GetChecked(),
            ["freqoff"] = self.DFOff:GetChecked(),
            ["poss104m"] = self.DMUnfit:GetChecked(),
            ["poss104p"] = self.DPUnfit:GetChecked()
        },
        ["cid"] = self.data.cid,
        ["localChanges"] = self.localChanges
    }

    for k, v in ipairs(self.DViolations:GetLines()) do
        if (v.actname == nil) then
            savingData.violations[#savingData.violations+1] = {
                ["vioname"] = v:GetColumnText(1),
                ["lvl"] = v:GetColumnText(2),
                ["lp"] = v:GetColumnText(3),
                ["notes"] = v:GetColumnText(4)
            }
        end
    end

    for k, v in ipairs(self.DLoyal:GetLines()) do
        if (v.vioname == nil) then
            savingData.loyalacts[#savingData.loyalacts+1] = {
                ["actname"] = v:GetColumnText(1),
                ["lp"] = v:GetColumnText(2),
                ["notes"] = v:GetColumnText(3)
            }
        end
    end

    netstream.Start("SaveImprovedViewData", self.target, savingData)
end

function PANEL:ShowPopup(newPopups)
    if (self.popups != nil) then
        for k, v in ipairs(self.popups) do
            v:Close()
        end
    end

    self.popups = newPopups

    for k, v in ipairs(self.popups) do
        v.OnClose = function()
            self:ClosePopups(k)
            self.popups = nil
        end
    end

end

function PANEL:ClosePopups(startingKey)
    if (self.popups != nil) then
        for k, v in ipairs(self.popups) do
            v:Remove()
        end
    else
        return
    end
end

vgui.Register("ixImprovedViewData", PANEL, "DFrame")
