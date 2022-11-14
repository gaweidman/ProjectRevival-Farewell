
local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

Clockwork.kernel:IncludePrefixed("cl_hooks.lua");
Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");

-- Fix the default radio command
function PLUGIN:UpdateRadioCommand()
	local COMMAND = Clockwork.command:FindByID("Radio");
	COMMAND.tip = "Send a radio message out to other characters on your current radio channel.";
	COMMAND.text = "<string Text>";
	COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_DEATHCODE, CMD_FALLENOVER);
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		Clockwork.command:FindByID("R"):OnRun(player, arguments);
	end;

	COMMAND:Register();
end;