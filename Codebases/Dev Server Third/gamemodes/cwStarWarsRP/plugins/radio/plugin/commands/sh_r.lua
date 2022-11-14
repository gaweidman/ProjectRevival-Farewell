
local Clockwork = Clockwork;

local COMMAND = Clockwork.command:New("R");
COMMAND.tip = "Send a radio message out to other characters on your current radio channel.";
COMMAND.text = "<string Text>";
COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_DEATHCODE, CMD_FALLENOVER);
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	Clockwork.radio:SayRadio(player, table.concat(arguments, " "));
end;

COMMAND:Register();