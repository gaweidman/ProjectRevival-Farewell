-- The 'nice' name of the faction.
FACTION.name = "Imperial Officer"
-- A description used in tooltips in various menus.
FACTION.desc = "A higher-up in the Galactic Empire."
-- A color to distinguish factions from others, used for stuff such as
-- name color in OOC chat.
FACTION.color = Color(255, 255, 255)
-- Set the male model choices for character creation.
FACTION.models = {
	"models/npc/swbf_imperial_officer_ensign/swbf_imperial_officer_ensign_npc.mdl"
}
-- Set it so the faction requires a whitelist.
FACTION.isDefault = false

-- FACTION.index is defined when the faction is registered and is just a numeric ID.
-- Here, we create a global variable for easier reference to the ID.
FACTION_IMPOFC = FACTION.index
