
local ITEM = Clockwork.item:New("armor_clothes_base");
ITEM.name = "Ranger Armor";
ITEM.uniqueID = "ranger_armor";
ITEM.actualWeight = 30;
ITEM.invSpace = 8;
ITEM.radiationResistance = 0.25;
ITEM.maxArmor = 150;
ITEM.protection = 0.55;
ITEM.business = false;
ITEM.gasmask = true;
ITEM.replacement = "models/ncr/rangercombatarmor.mdl";
ITEM.description = "A full suit of second-generation riot-gear armor used by veteran rangers.";

ITEM:Register();