--[[
	© 2012 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("weapon_base"); -- Derives from the weapon_base item in Clockwork.

ITEM.name = "Example Gun"; -- What is the name of this weapon?
ITEM.access = "e"; -- What flags are required to purchase this weapon? (Remove the line to not require flags)
ITEM.business = true; -- Is this ammo available for purchase from the business menu?
ITEM.classes = {CLASS_EXAMPLE}; -- What classes can purchase this item? (Remove the line to not require a specific class)
ITEM.description = "An example weapon item.";  -- A short description of the weapon.
ITEM.hasFlashlight = true; -- Will this weapon let you use your flashlight when wielded?
ITEM.isAttachment = true; -- Will this weapon be visible on the player's model when not wielded?
ITEM.model = "models/weapons/w_pistol.mdl"; -- What is the model of this item?
ITEM.uniqueID = "weapon_pistol"; -- This needs to be unique. (Remove the line to have a unique ID generated)
ITEM.weight = 1; -- What is the weight of the weapon in KG?

ITEM.attachmentBone = "ValveBiped.Bip01_Pelvis"; -- Where will this weapon be attached when the weapon is not wielded?
ITEM.attachmentOffsetAngles = Angle(0, 0, 90); -- What are the angles going to be for the weapon?
ITEM.attachmentOffsetVector = Vector(0, 4, -8); -- Where will the weapon be located on the player's model?
ITEM.loweredAngles = Angle(0, 45, 0); -- What are the angles for the weapon's viewmodel when lowered?
ITEM.loweredOrigin = Vector(3, 0, -4); -- Where will the weapon's viewmodel be located when lowered?

ITEM:Register();