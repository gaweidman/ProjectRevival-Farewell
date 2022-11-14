--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ATTRIBUTE = Clockwork.attribute:New();

ATTRIBUTE.name = "Dexterity";
ATTRIBUTE.maximum = 75;
ATTRIBUTE.uniqueID = "dex";
ATTRIBUTE.description = "Affects your overall dexterity, e.g: how fast you can tie/untie.";
ATTRIBUTE.isOnCharScreen = true;

ATB_DEXTERITY = Clockwork.attribute:Register(ATTRIBUTE);