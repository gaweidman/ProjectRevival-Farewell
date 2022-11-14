--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ATTRIBUTE = Clockwork.attribute:New();

ATTRIBUTE.name = "Agility";
ATTRIBUTE.maximum = 75;
ATTRIBUTE.uniqueID = "agt";
ATTRIBUTE.description = "Affects your overall speed, e.g: how fast you run.";
ATTRIBUTE.isOnCharScreen = true;

ATB_AGILITY = Clockwork.attribute:Register(ATTRIBUTE);