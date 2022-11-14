--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("weapon_base");

ITEM.name = "EC-17";
ITEM.cost = 0;
ITEM.model = "models/weapons/synbf3/w_scoutblaster.mdl";
ITEM.weight = 0.5;
ITEM.uniqueID = "weapon_752bf3_scoutblaster";
ITEM.business = false;
ITEM.description = "A small blaster with a short-range scope on the side.";
ITEM.isAttachment = true;
ITEM.loweredOrigin = Vector(3, 0, -4);
ITEM.loweredAngles = Angle(0, 45, 0);
ITEM.attachmentBone = "ValveBiped.Bip01_Pelvis";
ITEM.attachmentOffsetAngles = Angle(0, 0, 90);
ITEM.attachmentOffsetVector = Vector(0, 4, -8);

ITEM:Register();