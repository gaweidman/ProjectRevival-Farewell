
local ITEM = Clockwork.item:New("armor_clothes_base_customizable");
ITEM.name = "Customizable Gasmask Armor";
ITEM.uniqueID = "customizable_gasmask";
ITEM.hasGasmask = true;
ITEM.repairItem = "kevlar";
ITEM.repairAmount = 50;

Clockwork.item:Register(ITEM);