-- The 'nice' name of the faction.
FACTION.name = "Stormtrooper"
-- A description used in tooltips in various menus.
FACTION.desc = "A militant police officer of the Galactic Empire."
-- A color to distinguish factions from others, used for stuff such as
-- name color in OOC chat.
FACTION.color = Color(255, 255, 255)
-- Set the male model choices for character creation.
FACTION.models = {
	"models/npc/swbf_imperial_officer_nco/swbf_imperial_officer_nco_npc.mdl"
}
-- Set the female models to be the same as male models.
-- Set it so the faction requires a whitelist.
FACTION.isDefault = false

-- Return what the name will be set for character creation.
FACTION.pay = 25
FACTION.isGloballyRecognized = true

function FACTION:onGetDefaultName(client)
	return "394.RS-"..math.random(1111, 9999)
end
-- FACTION.index is defined when the faction is registered and is just a numeric ID.
-- Here, we create a global variable for easier reference to the ID.
FACTION_TK = FACTION.index
