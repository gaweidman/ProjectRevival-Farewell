
local ITEM = Clockwork.item:New("armor_clothes_base");
ITEM.name = "Desert Ranger Armor";
ITEM.uniqueID = "desert_ranger_armor";
ITEM.actualWeight = 30;
ITEM.invSpace = 8;
ITEM.radiationResistance = 0.45;
ITEM.maxArmor = 175;
ITEM.protection = 0.65;
ITEM.gasmask = true;
ITEM.business = false;
ITEM.replacement = "models/ncr/desertranger.mdl";
ITEM.description = "A full suit of second-generation riot-gear armor used by veteran rangers.";

ITEM:Register();