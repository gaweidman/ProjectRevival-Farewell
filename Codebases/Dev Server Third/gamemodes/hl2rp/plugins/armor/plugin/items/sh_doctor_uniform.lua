
local ITEM = Clockwork.item:New("armor_clothes_base");
ITEM.name = "Medic Uniform";
ITEM.uniqueID = "medic_uniform";
ITEM.actualWeight = 10;
ITEM.invSpace = 3;
ITEM.radiationResistance = 0.05;
ITEM.maxArmor = 25;
ITEM.protection = 0.2;
ITEM.cost = 100;
ITEM.business = true;
ITEM.access = "t";
ITEM.group = "group03m";
ITEM.description = "A leather suit patched with several types of metal along with a medical symbol.";

ITEM:Register();