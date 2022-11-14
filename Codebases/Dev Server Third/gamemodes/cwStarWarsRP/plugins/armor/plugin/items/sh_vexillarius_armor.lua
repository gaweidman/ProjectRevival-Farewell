
local ITEM = Clockwork.item:New("armor_clothes_base");
ITEM.name = "Vexillarius Armor";
ITEM.uniqueID = "vexillarius_armor";
ITEM.actualWeight = 20;
ITEM.invSpace = 4;
ITEM.radiationResistance = 0.01;
ITEM.maxArmor = 50;
ITEM.protection = 0.30;
ITEM.cost = 0;
ITEM.business = false;
ITEM.replacement = "models/cl/military/frumentarii.mdl";
ITEM.description = "A dark red outfit with a hide hood. The armor is padded with various scraps and bits.";


ITEM:Register();