
local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("SC");
COMMAND.tip = "Sets the radio channel you are transmitting on.";
COMMAND.text = "<string ChannelName> [int ChannelNumber|Default: 1]";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	Clockwork.command:FindByID("SetChannel"):OnRun(player, arguments);
end;

COMMAND:Register();