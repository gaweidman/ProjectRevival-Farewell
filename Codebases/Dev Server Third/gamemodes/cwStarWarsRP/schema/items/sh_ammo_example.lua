--[[
	© 2012 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("ammo_base"); -- Derives from the ammo_base item in Clockwork.

ITEM.name = "Example Ammo"; -- What is the name of this ammo?
ITEM.access = "e"; -- What flags are required to purchase this ammo? (Remove this line to not require flags)
ITEM.ammoAmount = 21; -- How much ammo does this item give us?
ITEM.ammoClass = "357"; -- What type of ammo does this item give us?
ITEM.business = true; -- Is this ammo available for purchase from the business menu?
ITEM.classes = {CLASS_EXAMPLE}; -- What classes can purchase this item? (Remove this line to not require a specific class)
ITEM.cost = 40; -- How much does this ammo cost?
ITEM.description = "An example ammo item."; -- A short description of the ammo.
ITEM.model = "models/items/357ammo.mdl"; -- What is the model of this item?
ITEM.uniqueID = "ammo_example"; -- This needs to be unique. (Remove this line to have a unique ID generated)
ITEM.weight = 1; -- What is the weight of the ammo in KG?

ITEM:Register();