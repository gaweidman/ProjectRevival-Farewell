
local ITEM = Clockwork.item:New("armor_clothes_base_customizable");
ITEM.name = "Customizable Power Armor";
ITEM.uniqueID = "customizable_pa";
ITEM.isPA = true;
ITEM.repairItem = "metal";
ITEM.repairAmount = 50;

Clockwork.item:Register(ITEM);