local ITEM = Clockwork.item:New("armor_clothes_base");

ITEM.name = "T-45d Power Armor";
ITEM.uniqueID = "t45d_pa";
ITEM.actualWeight = 40;
ITEM.invSpace = 8;
ITEM.radiationResistance = 1;
ITEM.maxArmor = 200;
ITEM.protection = 0.7;
ITEM.business = false;
ITEM.isPA = true;
ITEM.replacement = "models/power_armor/t45a.mdl";
ITEM.description = "A fully functioning suit of T-45d Power Armor in its default color.";
ITEM.repairItem = "tin_can";

Clockwork.item:Register(ITEM);