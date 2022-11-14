--[[
	� CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local CLASS = Clockwork.class:New("Stormtrooper Recruit");
	CLASS.color = Color(50, 100, 150, 255);
	CLASS.wages = 10;
	CLASS.factions = {FACTION_MPF};
	CLASS.wagesName = "Supplies";
	CLASS.description = "A stormtrooper recruit.";
	CLASS.defaultPhysDesc = "Wearing stormtrooper armor.";
CLASS_TKR = CLASS:Register();