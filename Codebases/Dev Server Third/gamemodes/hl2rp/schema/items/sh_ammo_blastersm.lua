--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("ammo_base");

ITEM.name = "Blaster Rounds";
ITEM.cost = 0;
ITEM.model = "models/starwars/items/shield.mdl";
ITEM.plural = "Blaster Rounds";
ITEM.weight = 1;
ITEM.uniqueID = "touch_pickup_752_ammo_ar2";
ITEM.business = false;
ITEM.ammoClass = "ar2";
ITEM.ammoAmount = 50;
ITEM.description = "A pack of blaster rounds. They almost look like batteries.";

ITEM:Register();