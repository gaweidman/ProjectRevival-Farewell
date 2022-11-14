--[[
local CHANNEL = Clockwork.radio:New();
CHANNEL.name = "squad";
CHANNEL.uniqueID = "mi_squad";
CHANNEL.subChannels = 9;
CHANNEL.global = false;
CHANNEL.defaultPriority = 10;

CHANNEL:Register();]]