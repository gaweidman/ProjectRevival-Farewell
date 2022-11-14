
local ITEM = Clockwork.item:New("armor_clothes_base_customizable");
ITEM.name = "Customizable Clothes";
ITEM.uniqueID = "customizable_clothes";
ITEM.repairItem = "cloth";
ITEM.repairAmount = 25;

Clockwork.item:Register(ITEM);