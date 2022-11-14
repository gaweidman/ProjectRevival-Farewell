--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ATTRIBUTE = Clockwork.attribute:New();

ATTRIBUTE.name = "Endurance";
ATTRIBUTE.maximum = 75;
ATTRIBUTE.uniqueID = "end";
ATTRIBUTE.description = "Affects your overall endurance, e.g: how much pain you can take.";
ATTRIBUTE.isOnCharScreen = true;

ATB_ENDURANCE = Clockwork.attribute:Register(ATTRIBUTE);