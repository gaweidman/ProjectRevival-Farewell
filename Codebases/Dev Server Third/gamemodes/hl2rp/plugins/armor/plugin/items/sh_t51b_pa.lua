local ITEM = Clockwork.item:New("armor_clothes_base");
ITEM.name = "T-51d Power Armor";
ITEM.uniqueID = "t51b_pa";
ITEM.actualWeight = 40;
ITEM.invSpace = 8;
ITEM.radiationResistance = 1;
ITEM.maxArmor = 250;
ITEM.protection = 0.75;
ITEM.business = false;
ITEM.isPA = true;
ITEM.replacement = "models/t51b/t51a.mdl";
ITEM.description = "A fully functioning suit of clean T-51b Power Armor.";

Clockwork.item:Register(ITEM);