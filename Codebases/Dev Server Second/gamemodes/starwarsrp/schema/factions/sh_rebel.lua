-- The 'nice' name of the faction.
FACTION.name = "Rebel"
-- A description used in tooltips in various menus.
FACTION.desc = "A common rebel."
FACTION.isGloballyRecognized = true
-- A color to distinguish factions from others, used for stuff such as
-- name color in OOC chat.
FACTION.color = Color(124, 98, 42)

FACTION.isDefault = false

FACTION.models = {
	"models/Kleiner.mdl"
}

-- FACTION.index is defined when the faction is registered and is just a numeric ID.
-- Here, we create a global variable for easier reference to the ID.
FACTION_REBEL = FACTION.index
