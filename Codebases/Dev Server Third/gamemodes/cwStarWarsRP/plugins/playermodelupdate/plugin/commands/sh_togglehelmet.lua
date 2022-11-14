
local COMMAND = Clockwork.command:New("ToggleHelmet");
COMMAND.tip = "Toggles your helmet on/off.";
COMMAND.flags = CMD_DEFAULT;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local model = player:GetModel();
	-- Check if player has the correct model (the '^' matches to the start of the string)
	if (string.find(model, "^models/senscith/sst/mi/")) then
		-- Get the player's toggle bodygroups
		local toggleBodygroup = player:GetCharacterData("toggle_bodygroup", {});
		-- If there is no table for this model yet or it is not set to one, and the player's bodygroup is not one
		if ((!toggleBodygroup[model] or toggleBodygroup[model]["1"] != 1) and player:GetBodygroup(1) != 1) then
			-- Ensure the table is made
			toggleBodygroup[model] = toggleBodygroup[model] or {};
			-- Set the value
			toggleBodygroup[model]["1"] = 1;
			Clockwork.player:Notify(player, "You have put on your helmet.");
		else
			-- Ensure we have a table to avoid lua errors
			toggleBodygroup[model] = toggleBodygroup[model] or {};
			-- Set bodygroup 1 to nil so it reverts to 0/whatever it should be add
			toggleBodygroup[model]["1"] = nil;
			Clockwork.player:Notify(player, "You have taken off your helmet.");
		end;
		-- Update character data
		player:SetCharacterData("toggle_bodygroup", toggleBodygroup);
		-- Update player's bodygroups
		player:SetBodyGroups();
	else
		Clockwork.player:Notify(player, "Your model cannot equip a helmet.");
	end;
end;

COMMAND:Register();
-- Add F1 menu option
if (CLIENT) then
	Clockwork.quickmenu:AddCallback("Toggle Helmet", nil, function()
		local commandTable = Clockwork.command:FindByID("ToggleHelmet");
		
		if (commandTable) then
			return {
				toolTip = commandTable.tip,
				Callback = function(option)
					Clockwork.kernel:RunCommand("ToggleHelmet");
				end
			};
		else
			return false;
		end;
	end);
end;