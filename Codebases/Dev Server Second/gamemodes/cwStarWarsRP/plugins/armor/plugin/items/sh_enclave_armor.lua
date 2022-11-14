--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("armor_clothes_base");
ITEM.name = "Enclave Power Armor";
ITEM.uniqueID = "enclave_power_armor";
ITEM.actualWeight = 40;
ITEM.invSpace = 8;
ITEM.radiationResistance = 1;
ITEM.maxArmor = 200;
ITEM.protection = 0.4;
ITEM.business = false;
ITEM.isPA = true;
ITEM.replacement = "models/nikout/advancedpowerarmor.mdl";
ITEM.description = "A full suit of enclave-designed advanced power armor.";

--ITEM:Register();