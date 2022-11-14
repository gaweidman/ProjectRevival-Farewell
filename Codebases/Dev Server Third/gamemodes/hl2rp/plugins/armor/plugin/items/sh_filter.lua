
local ITEM = Clockwork.item:New("filter_base");
ITEM.name = "Filter";
ITEM.model = "models/teebeutel/metro/objects/gasmask_filter.mdl";
ITEM.weight = 0.50;
ITEM.maxFilterQuality = 90000;
ITEM.useText = "Screw On";
ITEM.description = "Filters poisonous and radioactive gasses to a safe level.";
ITEM.refillItem = "charcoal";

Clockwork.item:Register(ITEM);