
local ITEM = Clockwork.item:New("armor_clothes_base");
ITEM.name = "Reinforced Combat Armor";
ITEM.uniqueID = "combat_armor";
ITEM.actualWeight = 20;
ITEM.invSpace = 5;
ITEM.radiationResistance = 0.3;
ITEM.maxArmor = 110;
ITEM.protection = 0.3;
ITEM.gasmask = true;
ITEM.cost = 200;
ITEM.business = true;
ITEM.access = "A";
ITEM.replacement = "models/humans/conscripts/gasmask_07.mdl";
ITEM.description = "A reinforced version of combat armor used before the Great War. ";

ITEM:Register();