
local ITEM = Clockwork.item:New("armor_clothes_base");
ITEM.name = "Lightweight Metal Armor";
ITEM.uniqueID = "light_metal_armor";
ITEM.actualWeight = 8;
ITEM.invSpace = 5;
ITEM.radiationResistance = 0.2;
ITEM.maxArmor = 100;
ITEM.protection = 0.2;
ITEM.business = true;
ITEM.access = "A";
ITEM.group = "group51";
ITEM.description = "A lightweight piece of metal attached to a strap of leather armor.";

ITEM:Register();