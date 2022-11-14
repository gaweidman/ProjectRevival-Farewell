
local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

-- Called when the top screen HUD should be painted.
function PLUGIN:HUDPaintTopScreen(info)
	local blackFadeAlpha = Clockwork.kernel:GetBlackFadeAlpha();
	local colorWhite = Clockwork.option:GetColor("white");
	local height = draw.GetFontHeight("BudgetLabel");

	local helmet = Clockwork.Client:GetSharedVar("helmet");
	-- Player is actually wearing a helmet so add in the HUD text
	if (helmet and helmet != "" and helmet != "none") then
		if (helmet == 1) then
			helmet = "helmet";
		elseif (helmet == 2) then
			helmet = "beret";
		end;
		
		draw.SimpleText("Headgear: "..helmet, "BudgetLabel", info.x, info.y, textColor);
		info.y = info.y + height;
	end;
end;