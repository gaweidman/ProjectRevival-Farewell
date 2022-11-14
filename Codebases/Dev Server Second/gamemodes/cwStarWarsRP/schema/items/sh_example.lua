--[[
	© 2012 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New(); -- Derives from no base.

ITEM.name = "Example Item"; -- What is the name of this item?
ITEM.access = "e"; -- What flags are required to purchase this item (remove the line to not require flags).
ITEM.business = true; -- Is this item available for purchase from the business menu?
ITEM.classes = {CLASS_EXAMPLE}; -- What classes can purchase this item (remove the line to not require a specific class).
ITEM.cost = 10; -- How much does this item cost?
ITEM.description = "An example item."; -- A short description of the item.
ITEM.model = "models/items/357ammo.mdl"; -- What is the model of this item?
ITEM.useText = "Example"; -- What is the text that should replace "Use" when interacting with the item (remove the line to use the default Use name)?
ITEM.weight = 1; -- What is the weight of the item in KG?

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	print("You just used an example item!");
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();