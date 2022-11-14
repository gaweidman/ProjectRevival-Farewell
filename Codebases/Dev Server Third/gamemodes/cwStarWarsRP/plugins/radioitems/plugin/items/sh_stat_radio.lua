local ITEM = Clockwork.item:New("stationary_radio_base");

ITEM.name = "Stationary Radio";
ITEM.uniqueID = "stat_radio";
ITEM.model = "models/props_lab/citizenradio.mdl";
ITEM.weight = 5;
ITEM.category = "Communication";
ITEM.business = false;
ITEM.description = "A stationary radio, has a frequency tuner on it.";

ITEM:Register();