
local COMMAND = Clockwork.command:New("SetLBV");
COMMAND.tip = "Set your LBV bodygroup to the given number.";
COMMAND.text = "[int LBV (0, 1, 2, 3, 4)]";
COMMAND.flags = CMD_DEFAULT;
COMMAND.optionalArguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local model = player:GetModel();
	
	if (string.find(model, "^models/senscith/sst/mi/")) then
		local state = tonumber(arguments[1]);
		if (state) then
			state = math.Round(math.Clamp(state, 0, 4));
		end;

		local toggleBodygroup = player:GetCharacterData("toggle_bodygroup", {});

		if (!state) then
			toggleBodygroup[model] = toggleBodygroup[model] or {};
			toggleBodygroup[model]["9"] = nil;
			Clockwork.player:Notify(player, "You have taken off your LBV.");
		else
			toggleBodygroup[model] = toggleBodygroup[model] or {};
			toggleBodygroup[model]["9"] = state;
			Clockwork.player:Notify(player, "You have set your LBV bodygroup to "..state..".");
		end;

		player:SetCharacterData("toggle_bodygroup", toggleBodygroup);
		player:SetBodyGroups();
	else
		Clockwork.player:Notify(player, "Your model cannot equip a LBV.");
	end;
end;

COMMAND:Register();
-- Add F1 menu option
if (CLIENT) then
	Clockwork.quickmenu:AddCommand("LBV", "Set Bodygroup", "SetLBV", {{"none", 0}, {"all around #1", 1}, {"infantry", 2}, {"light utility", 3}, {"all around #2", 4}});
end;