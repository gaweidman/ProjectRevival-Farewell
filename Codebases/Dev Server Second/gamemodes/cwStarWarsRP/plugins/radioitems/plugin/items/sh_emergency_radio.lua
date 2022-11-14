
local ITEM = Clockwork.item:New();
ITEM.name = "Emergency Radio";
ITEM.uniqueID = "emergency_radio";
ITEM.model = "models/deadbodies/dead_male_civilian_radio.mdl";
ITEM.weight = 1;
ITEM.category = "Communication";
ITEM.business = false;
ITEM.description = "A red and orange emergency radio.";
ITEM.frequency = "emergency";
ITEM.frequencyID = "freq_emergency";
ITEM.frequencySound = "npc/overwatch/radiovoice/off2.wav";
ITEM.frequencyColor = Color(255, 0, 0);
ITEM.frequencyPriority = 4;
ITEM.stationaryCanAccess = true;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();