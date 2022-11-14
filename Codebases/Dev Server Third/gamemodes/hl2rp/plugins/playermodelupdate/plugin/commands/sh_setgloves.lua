
local COMMAND = Clockwork.command:New("SetGloves");
COMMAND.tip = "Set your gloves bodygroup to the given number.";
COMMAND.text = "[int gloves (0, 1, (2)]";
COMMAND.flags = CMD_DEFAULT;
COMMAND.optionalArguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local model = player:GetModel();
	
	if (string.find(model, "^models/lt_c/sci_fi/humans/")) then
		local state = tonumber(arguments[1]);
		if (state) then
			state = math.Round(math.Clamp(state, 0, 1));
		end;

		local toggleBodygroup = player:GetCharacterData("toggle_bodygroup", {});

		if (!state) then
			toggleBodygroup[model] = toggleBodygroup[model] or {};
			toggleBodygroup[model]["7"] = nil;
			Clockwork.player:Notify(player, "You have taken off your gloves.");
		else
			toggleBodygroup[model] = toggleBodygroup[model] or {};
			toggleBodygroup[model]["7"] = state;
			Clockwork.player:Notify(player, "You have set your gloves bodygroup to "..state..".");
		end;

		player:SetCharacterData("toggle_bodygroup", toggleBodygroup);
		player:SetBodyGroups();
	elseif (string.find(model, "^models/senscith/sst/mi/")) then
		local state = tonumber(arguments[1]);
		if (state) then
			state = math.Round(math.Clamp(state, 0, 2));
		end;

		local toggleBodygroup = player:GetCharacterData("toggle_bodygroup", {});

		if (!state) then
			toggleBodygroup[model] = toggleBodygroup[model] or {};
			toggleBodygroup[model]["3"] = nil;
			Clockwork.player:Notify(player, "You have taken off your gloves.");
		else
			toggleBodygroup[model] = toggleBodygroup[model] or {};
			toggleBodygroup[model]["3"] = state;
			Clockwork.player:Notify(player, "You have set your gloves bodygroup to "..state..".");
		end;

		player:SetCharacterData("toggle_bodygroup", toggleBodygroup);
		player:SetBodyGroups();
	else
		Clockwork.player:Notify(player, "Your model cannot equip a gloves.");
	end;
end;

COMMAND:Register();
-- Add F1 menu option
if (CLIENT) then
	Clockwork.quickmenu:AddCommand("Gloves", "Set Bodygroup", "SetGloves", {{"none", 0}, {"full", 1}, {"fingerless", 2}});
end;