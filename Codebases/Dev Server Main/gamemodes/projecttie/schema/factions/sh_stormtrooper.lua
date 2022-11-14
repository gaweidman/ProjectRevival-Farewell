-- The 'nice' name of the faction.
FACTION.name = "Stormtrooper"
-- A description used in tooltips in various menus.
FACTION.desc = "A militant police officer of the Galactic Empire."
-- A color to distinguish factions from others, used for stuff such as
-- name color in OOC chat.
FACTION.color = Color(255, 255, 255)
-- Set the male model choices for character creation.
FACTION.maleModels = {
	"models/player/swbf_imperial_officer_ncov2/swbf_imperial_officer_ncov2.mdl"
}
-- Set the female models to be the same as male models.
FACTION.femaleModels = FACTION.maleModels
-- Set it so the faction requires a whitelist.
FACTION.isDefault = false

-- Return what the name will be set for character creation.
function FACTION:GetDefaultName()
	return "RS/394:"..math.random(1111, 9999)..""
end

-- FACTION.index is defined when the faction is registered and is just a numeric ID.
-- Here, we create a global variable for easier reference to the ID.
FACTION_TK = FACTION.index
