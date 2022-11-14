
local COMMAND = Clockwork.command:New("CharSetScale");
COMMAND.tip = "Sets a player's scale.";
COMMAND.text = "<string Name> [number Scale|Default: 1]";
COMMAND.access = "a";
COMMAND.arguments = 1;
COMMAND.optionalArguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);
	
	if (target) then
		local scale = tonumber(arguments[2]);
		if (!scale) then
			scale = 1
		end;

		scale = math.Clamp(scale, 0.9, 1.1);

		if (target != player) then
			Clockwork.player:Notify(player, "You have set "..target:Name().."'s model scale from "..target:GetCharacterData("model_scale", 1).." to "..scale..".");
			Clockwork.player:Notify(target, player:Name().." has set your model scale from "..target:GetCharacterData("model_scale", 1).." to "..scale..".");
		else
			Clockwork.player:Notify(player, "You have set your own scale from "..target:GetCharacterData("model_scale", 1).." to "..scale..".");
		end;

		target:SetCharacterData("model_scale", scale);
		player:SetPlayerScale();
	else
		Clockwork.player:Notify(player, arguments[1].." is not a valid character!");
	end;
end;

COMMAND:Register();