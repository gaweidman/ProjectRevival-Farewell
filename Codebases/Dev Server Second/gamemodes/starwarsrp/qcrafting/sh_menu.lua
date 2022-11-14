if SERVER then return end
local PLUGIN = PLUGIN

local PANEL = {}

    function PANEL:Init()
        print("Init Running")
    
    function PANEL:Think()
            if (!self:IsActive()) then
                print("Thinking, and self is not active.")
            end
        end
    end

vgui.Register("nut_crafting", PANEL, "DFrame")

function PLUGIN:CreateMenuButtons(tabs)--menu, addButton)
    tabs["Crafting"] = function(panel)
        --if removeGuiMenu then nut.gui.menu:Remove() end
        local scroll = panel:Add("DScrollPanel")
        scroll:Dock(FILL)
        
        local properties = scroll:Add("DProperties")
        properties:SetSize(panel:GetSize())

        nut.gui.properties = properties

    end
end