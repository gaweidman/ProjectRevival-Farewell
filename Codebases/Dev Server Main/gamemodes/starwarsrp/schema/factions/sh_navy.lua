-- The 'nice' name of the faction.
FACTION.name = "Navy"
-- A description used in tooltips in various menus.
FACTION.description = "A higher-up in the Galactic Empire."
-- A color to distinguish factions from others, used for stuff such as
-- name color in OOC chat.
FACTION.color = Color(20, 204, 204)
FACTION.isGloballyRecognized = true
-- Set the male model choices for character creation.
FACTION.models = {
    "models/kriegsyntax/imperial/navy/recruit/playermodel_male_01.mdl"
}
-- Set it so the faction requires a whitelist.
FACTION.isDefault = true

-- FACTION.index is defined when the faction is registered and is just a numeric ID.
-- Here, we create a global variable for easier reference to the ID.
FACTION_NAVY = FACTION.index
