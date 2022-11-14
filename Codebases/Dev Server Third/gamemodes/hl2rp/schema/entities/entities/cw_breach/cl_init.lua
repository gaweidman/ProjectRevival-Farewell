--[[
	� CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

include("shared.lua");

-- Called when the target ID HUD should be painted.
function ENT:HUDPaintTargetID(x, y, alpha)
	local colorTargetID = Clockwork.option:GetColor("target_id");
	local colorWhite = Clockwork.option:GetColor("white");
	
	y = Clockwork.kernel:DrawInfo(L("Breach"), x, y, colorTargetID, alpha);
	y = Clockwork.kernel:DrawInfo(L("BreachTargetID"), x, y, colorWhite, alpha);
end;

-- Called when the entity should draw.
function ENT:Draw() self:DrawModel(); end;