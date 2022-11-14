
local PLUGIN = PLUGIN;
local Clockwork = Clockwork;
local playerMeta = FindMetaTable("Player");

Clockwork.config:Add("no_noclip_eavesdrop", true); -- Can we not eavesdrop people in observer?

function playerMeta:SetChannels()
	Clockwork.radio:SetPlayerChannels(self)
end;

function playerMeta:AddChannel(channel, channelNumber)
	Clockwork.radio:AddChannelToPlayer(player, channel, channelNumber)
end;