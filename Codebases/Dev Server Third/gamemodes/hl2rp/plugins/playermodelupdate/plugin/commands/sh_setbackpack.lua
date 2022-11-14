
local COMMAND = Clockwork.command:New("SetBackpack");
COMMAND.tip = "Set your backpack bodygroup to the given number.";
COMMAND.text = "[int Backpack (0, 1, 2, 3, 4)]";
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
			toggleBodygroup[model]["8"] = nil;
			Clockwork.player:Notify(player, "You have taken off your backpack.");
		else
			toggleBodygroup[model] = toggleBodygroup[model] or {};
			toggleBodygroup[model]["8"] = state;
			Clockwork.player:Notify(player, "You have set your backpack bodygroup to "..state..".");
		end;

		player:SetCharacterData("toggle_bodygroup", toggleBodygroup);
		player:SetBodyGroups();
	else
		Clockwork.player:Notify(player, "Your model cannot equip a backpack.");
	end;
end;

COMMAND:Register();
-- Add F1 menu option
if (CLIENT) then
	Clockwork.quickmenu:AddCommand("Backpack", "Set Bodygroup", "SetBackpack", {{"none", 0}, {"standard", 1}, {"large utility", 2}, {"quick access", 3}, {"zipper pouch", 4}});
end;