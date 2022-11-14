--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("armor_clothes_base");
ITEM.name = "Pre-War Waist Coat";
ITEM.uniqueID = "waistcoat";
ITEM.actualWeight = 5;
ITEM.invSpace = 2;
ITEM.radiationResistance = 0.01;
ITEM.maxArmor = 0;
ITEM.protection = 0.01;
ITEM.cost = 100;
ITEM.business = true;
ITEM.access = "t";
ITEM.description = "A set of business attire for any wealthy person.";

function ITEM:GetReplacement(player) 
	return "models/suits/"..self:GetModelName(player).."_open_waistcoat.mdl";
end;

ITEM:Register();