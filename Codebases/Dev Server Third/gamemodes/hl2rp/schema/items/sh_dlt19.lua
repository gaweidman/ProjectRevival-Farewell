--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("weapon_base");

ITEM.name = "DLT-19";
ITEM.cost = 0;
ITEM.model = "models/weapons/synbf3/w_dlt19.mdl";
ITEM.weight = 5;
ITEM.uniqueID = "weapon_752bf3_dlt19";
ITEM.business = false;
ITEM.description = "A long, black blaster with an ironsight.";
ITEM.isAttachment = true;
ITEM.loweredOrigin = Vector(3, 0, -4);
ITEM.loweredAngles = Angle(0, 45, 0);
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
ITEM.attachmentOffsetAngles = Angle(0, 0, 0);
ITEM.attachmentOffsetVector = Vector(-3.96, 4.95, -2.97);
ITEM:Register();