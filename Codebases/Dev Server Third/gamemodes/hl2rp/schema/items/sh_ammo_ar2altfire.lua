--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("ammo_base");

ITEM.name = "ItemPulseRifleOrb";
ITEM.cost = 80;
ITEM.classes = {CLASS_EOW};
ITEM.model = "models/items/combine_rifle_ammo01.mdl";
ITEM.weight = 1;
ITEM.uniqueID = "ammo_ar2altfire";
ITEM.business = true;
ITEM.ammoClass = "ar2altfire";
ITEM.ammoAmount = 1;
ITEM.description = "ItemPulseRifleOrbDesc";

ITEM:Register();