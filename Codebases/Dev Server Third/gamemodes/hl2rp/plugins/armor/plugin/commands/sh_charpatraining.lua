
local Clockwork = Clockwork;

local COMMAND = Clockwork.command:New("charPaTraining");
COMMAND.tip = "Get/Set a character's PA training level (0-3).";
COMMAND.text = "<string Name> [number Level]";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";
COMMAND.arguments = 1;
COMMAND.optionalArguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);
	
	if (target) then
		local amount = arguments[2];
		if (!amount) then
			local paTraining = target:GetCharacterData("paTraining") or 0;
			Clockwork.player:Notify(player, target:Name().."'s PA training level is "..paTraining..".");
		else
			amount = math.Round(math.Clamp(tonumber(amount), 0, 3));
			target:SetCharacterData("paTraining", amount);

			if (player != target)	then
				Clockwork.player:Notify(target, player:Name().." has set your PA training level to "..amount..".");
				Clockwork.player:Notify(player, "You have set "..target:Name().."'s PA training level to "..amount..".");
			else
				Clockwork.player:Notify(player, "You have set your own PA training level to "..amount..".");
			end;
		end;

	else
		Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
	end;
end;

COMMAND:Register();