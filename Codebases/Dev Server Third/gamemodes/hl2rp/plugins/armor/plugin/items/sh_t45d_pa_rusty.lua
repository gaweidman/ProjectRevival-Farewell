local ITEM = Clockwork.item:New("t45_pa");
ITEM.name = "Rusty T-45d Power Armor";
ITEM.uniqueID = "t45d_pa_rusty";
ITEM.radiationResistance = 0.99;
ITEM.maxArmor = 180;
ITEM.protection = 0.65;
ITEM.replacement = "models/power_armor/t45e.mdl";
ITEM.description = "A barely functioning rusty suit of T-45d Power Armor.";

Clockwork.item:Register(ITEM);