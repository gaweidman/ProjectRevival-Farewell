
local ITEM = Clockwork.item:New();
ITEM.name = "Public Radio";
ITEM.uniqueID = "public_radio";
ITEM.model = "models/deadbodies/dead_male_civilian_radio.mdl";
ITEM.weight = 1;
ITEM.category = "Communication";
ITEM.business = false;
ITEM.description = "A simple public radio. It only seems to have one frequency.";
ITEM.frequency = "public";

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();