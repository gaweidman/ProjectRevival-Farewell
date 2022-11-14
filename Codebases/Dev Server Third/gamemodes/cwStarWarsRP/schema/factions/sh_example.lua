--[[
	© 2012 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local FACTION = Clockwork.faction:New("Example");

FACTION.isWhitelisted = false; -- Do we need to be whitelisted to select this faction?
FACTION.useFullName = true; -- Do we allow players to enter a full name, otherwise it only lets them select a first and second.
FACTION.material = "path/to/material"; -- The path to the faction material (shown on the creation screen).

FACTION_EXAMPLE = FACTION:Register();