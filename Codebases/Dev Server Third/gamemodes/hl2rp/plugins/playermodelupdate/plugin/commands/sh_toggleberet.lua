
local COMMAND = Clockwork.command:New("ToggleBeret");
COMMAND.tip = "Toggles your beret on/off.";
COMMAND.flags = CMD_DEFAULT;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local model = player:GetModel();

	if (string.find(model, "^models/senscith/sst/mi/") or string.find(model, "^models/lt_c/sci_fi/humans/")) then
		local toggleBodygroup = player:GetCharacterData("toggle_bodygroup", {});

		if ((!toggleBodygroup[model] or toggleBodygroup[model]["1"] != 2) and player:GetBodygroup(1) != 2) then
			toggleBodygroup[model] = toggleBodygroup[model] or {};
			toggleBodygroup[model]["1"] = 2;
			Clockwork.player:Notify(player, "You have put on your beret.");
		else
			toggleBodygroup[model] = toggleBodygroup[model] or {};
			toggleBodygroup[model]["1"] = nil;
			Clockwork.player:Notify(player, "You have taken off your beret.");
		end;

		player:SetCharacterData("toggle_bodygroup", toggleBodygroup);
		player:SetBodyGroups();
	else
		Clockwork.player:Notify(player, "Your model cannot equip a beret.");
	end;
end;

COMMAND:Register();

if (CLIENT) then
	Clockwork.quickmenu:AddCallback("Toggle Beret", nil, function()
		local commandTable = Clockwork.command:FindByID("ToggleBeret");
		
		if (commandTable) then
			return {
				toolTip = commandTable.tip,
				Callback = function(option)
					Clockwork.kernel:RunCommand("ToggleBeret");
				end
			};
		else
			return false;
		end;
	end);
end;