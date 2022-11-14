-- The 'nice' name of the faction.
FACTION.name = "Stormtrooper"
-- A description used in tooltips in various menus.
FACTION.description = "A militant police officer of the Galactic Empire."
-- A color to distinguish factions from others, used for stuff such as
-- name color in OOC chat.
FACTION.color = Color(255, 255, 255)
FACTION.isGloballyRecognized = true
-- Set the male model choices for character creation.
FACTION.models = {
	"models/player/ven/tk_501_01/tk_501.mdl"
}

-- Set it so the faction requires a whitelist.
FACTION.isDefault = true

-- Return what the name will be set for character creation.
function FACTION:onGetDefaultName()
	return "Recruit TK-"..math.random(1111, 9999)
end

-- FACTION.index is defined when the faction is registered and is just a numeric ID.
-- Here, we create a global variable for easier reference to the ID.
FACTION_STORMTROOPER = FACTION.index
