-- The 'nice' name of the faction.
FACTION.name = "Miscellaneous"
-- A description used in tooltips in various menus.
FACTION.desc = "A miscellaneous faction."
-- A color to distinguish factions from others, used for stuff such as
-- name color in OOC chat.
FACTION.color = Color(255, 255, 255)
FACTION.isGloballyRecognized = true
-- Set the male model choices for character creation.
FACTION.models = {
    "models/Kleiner.mdl",
}
-- Set it so the faction requires a whitelist.
FACTION.isDefault = false

-- FACTION.index is defined when the faction is registered and is just a numeric ID.
-- Here, we create a global variable for easier reference to the ID.
FACTION_MISC = FACTION.index
