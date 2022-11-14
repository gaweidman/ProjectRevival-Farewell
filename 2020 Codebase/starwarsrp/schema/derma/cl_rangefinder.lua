
local PANEL = {}

function PANEL:Init()

	if (IsValid(ix.gui.rangefinder)) then
		ix.gui.rangefinder:Remove()
	end

	self:SetPos(0, 0)
	self:SetSize(ScrW(), ScrH())
    self:ParentToHUD()
    
    ix.gui.rangefinder = self
end

function PANEL:Paint(width, height)
    local eyetrace = self.owner:GetEyeTrace()
    surface.SetFont("Trebuchet24")
    
    surface.SetDrawColor( 255, 255, 255, 200 )
    surface.DrawOutlinedRect(89, 89, 102, draw.GetFontHeight("Trebuchet24") * 2 + 2, 1)
    --surface.DrawRect(89, 89, 102, draw.GetFontHeight("Trebuchet24") * 2 + 2)

    surface.SetDrawColor( 50, 50, 50, 200 )
    surface.DrawRect(90, 90, 100, draw.GetFontHeight("Trebuchet24") * 2)

    surface.SetTextColor(255, 255, 255, 255)
    surface.SetTextPos(90 + draw.GetFontHeight("Trebuchet24"), 100)
    if (eyetrace.Entity != nil) then
        local plyPos = self.owner:GetPos() + self.owner:GetCurrentViewOffset()
        local hitPos = eyetrace.HitPos
        local distance = math.Round(plyPos:Distance(hitPos)/(16*3.281))
        surface.DrawText(tostring(distance).." m")
    else
        surface.DrawText("NO HIT")
    end

	surface.SetDrawColor(Color(0, 0, 0, 255))
end

function PANEL:SetOwner(client)
    self.owner = client
end

vgui.Register("ixRangefinderDisplay", PANEL, "Panel")