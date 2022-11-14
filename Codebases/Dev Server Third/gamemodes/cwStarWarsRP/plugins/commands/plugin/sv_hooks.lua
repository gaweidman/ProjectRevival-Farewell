
local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

function PLUGIN:PlayerAdjustRadioInfo(player, info)
	if (player:IsNoClipping() or Clockwork.faction:FindByID(player:GetFaction()).noEavesdrop) then
		info.noEavesdrop = true;
	end;
end;