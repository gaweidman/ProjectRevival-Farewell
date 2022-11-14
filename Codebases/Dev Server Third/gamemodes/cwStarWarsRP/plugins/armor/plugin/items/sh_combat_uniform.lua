
local ITEM = Clockwork.item:New("armor_clothes_base");
ITEM.name = "Combat Uniform";
ITEM.uniqueID = "combat_uniform";
ITEM.actualWeight = 15;
ITEM.invSpace = 4;
ITEM.radiationResistance = 0.1;
ITEM.maxArmor = 25;
ITEM.protection = 0.3;
ITEM.cost = 100;
ITEM.business = true;
ITEM.access = "A";
ITEM.group = "conscripts";
ITEM.description = "A green vested piece of combat armor used before the Great War.";


ITEM:Register();