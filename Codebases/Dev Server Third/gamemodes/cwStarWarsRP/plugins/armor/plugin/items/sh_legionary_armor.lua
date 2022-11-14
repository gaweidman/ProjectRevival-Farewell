
local ITEM = Clockwork.item:New("armor_clothes_base");
ITEM.name = "Legionary Armor";
ITEM.uniqueID = "legionary_armor";
ITEM.actualWeight = 15;
ITEM.invSpace = 2.5;
ITEM.radiationResistance = 0.01;
ITEM.maxArmor = 35;
ITEM.protection = 0.15;
ITEM.cost = 0;
ITEM.business = false;
ITEM.replacement = "models/cl/military/legionrecruit.mdl";
ITEM.description = "A dark red outfit with a tribe-style hood padded with various scraps and bits.";


ITEM:Register();