--[[
	� CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local CLASS = Clockwork.class:New("Stormtrooper");
	CLASS.color = Color(50, 100, 150, 255);
	CLASS.wages = 20;
	CLASS.factions = {FACTION_TK};
	CLASS.isDefault = true;
	CLASS.wagesName = "Supplies";
	CLASS.description = "A stormtrooper.";
	CLASS.defaultPhysDesc = "Wearing stormtrooper armor.";
CLASS_MPU = CLASS:Register();