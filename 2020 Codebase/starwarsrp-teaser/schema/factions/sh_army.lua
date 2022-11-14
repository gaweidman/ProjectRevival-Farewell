-- The 'nice' name of the faction.
FACTION.name = "Droid"
-- A description used in tooltips in various menus.
FACTION.description = "Unknown"
-- A color to distinguish factions from others, used for stuff such as
-- name color in OOC chat.
FACTION.color = Color(171, 119, 15)
FACTION.isGloballyRecognized = true
-- Set the male model choices for character creation.
FACTION.models = {
    "models/kingpommes/starwars/misc/droids/mouse_droid.mdl"
}
-- Set it so the faction requires a whitelist.
FACTION.isDefault = true

-- FACTION.index is defined when the faction is registered and is just a numeric ID.
-- Here, we create a global variable for easier reference to the ID.
FACTION_DROID = FACTION.index
