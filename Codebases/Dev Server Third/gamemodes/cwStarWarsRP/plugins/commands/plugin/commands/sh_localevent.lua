
local COMMAND = Clockwork.command:New("LocalEvent");
COMMAND.tip = "Send an event to characters around you.";
COMMAND.text = "<string Text>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "o";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	Clockwork.chatBox:AddInRadius(player, "localevent",  table.concat(arguments, " "), player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 4);
end;

COMMAND:Register();