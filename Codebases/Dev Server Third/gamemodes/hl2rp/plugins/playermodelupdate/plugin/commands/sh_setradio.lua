
local COMMAND = Clockwork.command:New("SetRadio");
COMMAND.tip = "Set your radio bodygroup to the given number.";
COMMAND.text = "[int radio (0, 1, 2)]";
COMMAND.flags = CMD_DEFAULT;
COMMAND.optionalArguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local model = player:GetModel();
	
	if (string.find(model, "^models/senscith/sst/mi/")) then
		local state = tonumber(arguments[1]);
		if (state) then
			state = math.Round(math.Clamp(state, 0, 2));
		end;

		local toggleBodygroup = player:GetCharacterData("toggle_bodygroup", {});

		if (!state) then
			toggleBodygroup[model] = toggleBodygroup[model] or {};
			toggleBodygroup[model]["7"] = nil;
			Clockwork.player:Notify(player, "You have taken off your radio.");
		else
			toggleBodygroup[model] = toggleBodygroup[model] or {};
			toggleBodygroup[model]["7"] = state;
			Clockwork.player:Notify(player, "You have set your radio bodygroup to "..state..".");
		end;

		player:SetCharacterData("toggle_bodygroup", toggleBodygroup);
		player:SetBodyGroups();
	else
		Clockwork.player:Notify(player, "Your model cannot equip a radio.");
	end;
end;

COMMAND:Register();
-- Add F1 menu option
if (CLIENT) then
	Clockwork.quickmenu:AddCommand("Radio", "Set Bodygroup", "SetRadio", {{"none", 0}, {"front", 1}, {"back", 2}});
end;