--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("armor_clothes_base");
ITEM.name = "Enclave Hellfire Armor";
ITEM.uniqueID = "enclave_hellfire";
ITEM.actualWeight = 40;
ITEM.invSpace = 8;
ITEM.radiationResistance = 1;
ITEM.maxArmor = 300;
ITEM.protection = 0.55;
ITEM.isPA = true;
ITEM.business = false;
ITEM.replacement = "models/nikout/fallout/hellfirearmornpc.mdl";
ITEM.description = "A full suit of enclave-designed advanced hellfire power armor.";


ITEM:Register();