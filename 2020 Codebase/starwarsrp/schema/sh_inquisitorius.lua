-- The 'nice' name of the faction.
FACTION.name = "Inquisitorius"
-- A description used in tooltips in various menus.
FACTION.description = "A member of the inquisitorius."
FACTION.isGloballyRecognized = true
-- A color to distinguish factions from others, used for stuff such as
-- name color in OOC chat.
FACTION.color = Color(183, 0, 0)

FACTION.isDefault = false

FACTION.models = {
	"models/player/sample/purge/trooper/trooper.mdl"
}

-- FACTION.index is defined when the faction is registered and is just a numeric ID.
-- Here, we create a global variable for easier reference to the ID.
FACTION_INQUIS = FACTION.index
