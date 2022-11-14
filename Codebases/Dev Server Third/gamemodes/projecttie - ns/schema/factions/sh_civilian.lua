-- The 'nice' name of the faction.
FACTION.name = "Civilian"
-- A description used in tooltips in various menus.
FACTION.desc = "A common civilian of the Galactic Empire."
-- A color to distinguish factions from others, used for stuff such as
-- name color in OOC chat.
FACTION.color = Color(124, 98, 42)

FACTION.models = {
	"models/humans/group02/tale_01.mdl",
	"models/humans/group02/tale_03.mdl",
	"models/humans/group02/tale_04.mdl",
	"models/humans/group02/tale_05.mdl",
	"models/humans/group02/tale_06.mdl",
	"models/humans/group02/tale_07.mdl",
	"models/humans/group02/tale_08.mdl",
	"models/humans/group02/tale_09.mdl",
	"models/hgn/swrp/swrp/weequay_01.mdl",
	"models/humans/group02/temale_01.mdl",
	"models/humans/group02/temale_02.mdl",
	"models/humans/group02/temale_07.mdl",
	"models/hgn/swrp/swrp/citizen/group01/female_04.mdl",
	"models/hgn/swrp/swrp/citizen/group01/female_06.mdl",
	"models/hgn/swrp/swrp/citizen/group01/female_07.mdl"
}

-- FACTION.index is defined when the faction is registered and is just a numeric ID.
-- Here, we create a global variable for easier reference to the ID.
FACTION_CIVILIAN = FACTION.index
