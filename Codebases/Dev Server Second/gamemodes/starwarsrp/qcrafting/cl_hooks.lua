/*
hook.Add("CreateMenuButtons", "nutCrafting", function(tabs)
    tabs["Crafting"] = function(panel)
        local scroll = panel:Add("DScrollPanel")
        scroll:Dock(FILL)

        local properties = scroll:Add("DProperties")
        properties:SetSize(panel:GetSize())

        nut.gui.properties = properties

    end
)
*/