--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("weapon_base");

ITEM.name = "E-11 Blaster";
ITEM.cost = 0;
ITEM.model = "models/nate159/swbf2015/pewpew/e11.mdl";
ITEM.weight = 2;
ITEM.uniqueID = "weapon_752bf3_e11";
ITEM.business = false;
ITEM.description = "A clean, black blaster with a scope on top.";
ITEM.isAttachment = true;
ITEM.loweredOrigin = Vector(3, 0, -4);
ITEM.loweredAngles = Angle(0, 45, 0);
ITEM.attachmentBone = "ValveBiped.Bip01_Pelvis";
ITEM.attachmentOffsetAngles = Angle(0, 0, 90);
ITEM.attachmentOffsetVector = Vector(0, 4, -8);

ITEM:Register();