
local ITEM = Clockwork.item:New("armor_clothes_base");
ITEM.name = "Decanus Armor";
ITEM.uniqueID = "decanus_armor";
ITEM.actualWeight = 15;
ITEM.invSpace = 3;
ITEM.radiationResistance = 0.01;
ITEM.maxArmor = 45;
ITEM.protection = 0.25;
ITEM.cost = 0;
ITEM.business = false;
ITEM.replacement = "models/cl/military/legiondecanus.mdl";
ITEM.description = "A dark red outfit with a tribe-style chieftain hood padded with various scraps and bits.";


ITEM:Register();