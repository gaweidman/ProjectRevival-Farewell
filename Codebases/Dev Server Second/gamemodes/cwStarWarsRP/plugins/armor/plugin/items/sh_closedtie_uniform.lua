
local ITEM = Clockwork.item:New("armor_clothes_base");
ITEM.name = "Pre-War Business Suit";
ITEM.uniqueID = "business_suit";
ITEM.actualWeight = 2;
ITEM.invSpace = 2;
ITEM.radiationResistance = 0.01;
ITEM.maxArmor = 0;
ITEM.protection = 0.05;
ITEM.cost = 100;
ITEM.business = true;
ITEM.access = "t";
ITEM.description = "A set of business attire for any wealthy person.";

function ITEM:GetReplacement(player) 
	return "models/suits/"..self:GetModelName(player).."_closed_tie.mdl" 
end;

ITEM:Register();