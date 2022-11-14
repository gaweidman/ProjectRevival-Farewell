--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("armor_clothes_base");
ITEM.name = "Radiation Suit";
ITEM.uniqueID = "rad_suit";
ITEM.actualWeight = 20;
ITEM.invSpace = 4;
ITEM.radiationResistance = 1;
ITEM.maxArmor = 25;
ITEM.protection = 0.1;
ITEM.business = false;
ITEM.gasmask = true;
ITEM.replacement = "models/bio_suit/hell_bio_suit.mdl";
ITEM.description = "A full set of hazmat-style radiation protection suit. ";


ITEM:Register();