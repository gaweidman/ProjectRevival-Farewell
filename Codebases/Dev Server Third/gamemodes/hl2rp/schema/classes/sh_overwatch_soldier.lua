--[[
	� CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local CLASS = Clockwork.class:New("Imperial Officer");
	CLASS.color = Color(150, 50, 50, 255);
	CLASS.wages = 40;
	CLASS.factions = {FACTION_IMPOFF};
	CLASS.wagesName = "Supplies";
	CLASS.description = "An imperial officer.";
	CLASS.defaultPhysDesc = "Wearing a clean imperial officer uniform.";
CLASS_OWS = CLASS:Register();