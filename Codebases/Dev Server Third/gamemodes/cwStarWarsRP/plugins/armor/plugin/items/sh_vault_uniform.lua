--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("armor_clothes_base");
ITEM.name = "Vault Jumpsuit";
ITEM.uniqueID = "vault_suit";
ITEM.actualWeight = 5;
ITEM.invSpace = 4;
ITEM.radiationResistance = 0.1;
ITEM.maxArmor = 25;
ITEM.protection = 0.2;
ITEM.business = false;
ITEM.group = "groupv";
ITEM.description = "A vault suit constructed for the vault inhabitants underground.";


ITEM:Register();