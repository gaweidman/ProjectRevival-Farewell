
local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("ToggleFormalUniform");
COMMAND.tip = "Toggles your beret on/off.";
COMMAND.flags = CMD_DEFAULT;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local model = player:GetModel();

	if (string.find(model, "^models/lt_c/sci_fi/humans/")) then
		local toggleSkin = player:GetCharacterData("toggle_skin", {});

		if ((!toggleSkin[model] or toggleSkin[model] != 2) and player:GetSkin() != 2) then
			toggleSkin[model] = 2;
			Clockwork.player:Notify(player, "You have put on your formal uniform.");
		else
			toggleSkin[model] = nil;
			Clockwork.player:Notify(player, "You have taken off your formal uniform.");
		end;

		player:SetCharacterData("white_skins", toggleSkin);
		player:SetSkin(Clockwork.plugin:Call("GetPlayerDefaultSkin", player));
	else
		Clockwork.player:Notify(player, "Your model cannot equip a formal uniform.");
	end;
end;

--COMMAND:Register();
