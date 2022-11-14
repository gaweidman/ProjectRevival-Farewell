local PANEL = {}
    function PANEL:Init()
        local container = vgui.Create("Panel")
        container:SetPos(0, 0)	-- Move it into frame
        container:SetSize(ScrW(), ScrH())
        -- Image panel of Dr. Breen
        local breen_img = vgui.Create("DImage", container)	-- Add image to Frame
        breen_img:SetPos(0, 0)	-- Move it into frame
        breen_img:SetSize(ScrW(), ScrH())	-- Size it to 150x150

        -- Set material relative to "garrysmod/materials/"
        breen_img:SetImage("projecttie/BridgeCharSelect.png")

	end
vgui.Register("bridgeBackground", PANEL, "DImage")