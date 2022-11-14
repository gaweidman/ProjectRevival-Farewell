--[[
local CHANNEL = Clockwork.radio:New();
CHANNEL.name = "global";
CHANNEL.uniqueID = "mi_global_squad";
CHANNEL.subChannels = 1;
CHANNEL.global = true;
CHANNEL.defaultPriority = 8;
CHANNEL.targetChannels = {["mi_squad"] = "all"}

CHANNEL:Register();]]