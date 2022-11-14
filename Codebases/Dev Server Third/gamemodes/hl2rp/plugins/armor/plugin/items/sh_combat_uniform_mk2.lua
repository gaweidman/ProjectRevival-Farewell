
local ITEM = Clockwork.item:New("armor_clothes_base");
ITEM.name = "Reinforced Combat Armor Mk.II";
ITEM.uniqueID = "combat_armor_mk2";
ITEM.actualWeight = 25;
ITEM.invSpace = 6;
ITEM.radiationResistance = 0.4;
ITEM.maxArmor = 125;
ITEM.protection = 0.4;
ITEM.gasmask = true;
ITEM.cost = 200;
ITEM.business = true;
ITEM.access = "a";
ITEM.replacement = "models/quake4pm/quakencr.mdl";
ITEM.description = "A reinforced version of combat armor used before the Great War. ";

ITEM:Register();