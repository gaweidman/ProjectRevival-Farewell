--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("weapon_base");

ITEM.name = "DLT-20A";
ITEM.cost = 0;
ITEM.model = "models/weapons/w_pistol.mdl";
ITEM.weight = 5;
ITEM.uniqueID = "weapon_752bf3_dlt20a";
ITEM.business = false;
ITEM.description = "A long blaster with a long-range scope and a barrel full of venting holes.";
ITEM.isAttachment = true;
ITEM.loweredOrigin = Vector(3, 0, -4);
ITEM.loweredAngles = Angle(0, 45, 0);
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
ITEM.attachmentOffsetAngles = Angle(0, 0, 0);
ITEM.attachmentOffsetVector = Vector(-3.96, 4.95, -2.97);

ITEM:Register();