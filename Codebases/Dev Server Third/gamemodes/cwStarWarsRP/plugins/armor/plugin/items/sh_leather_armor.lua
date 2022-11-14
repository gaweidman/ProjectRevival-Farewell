--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("armor_clothes_base");
ITEM.name = "Leather Armor";
ITEM.uniqueID = "leather_armor";
ITEM.actualWeight = 12;
ITEM.invSpace = 4;
ITEM.radiationResistance = 0.05;
ITEM.maxArmor = 25;
ITEM.protection = 0.25;
ITEM.cost = 100;
ITEM.business = true;
ITEM.access = "A";
ITEM.group = "group03";
ITEM.description = "A leather suit patched with different scraps of metal and fiber.";


ITEM:Register();