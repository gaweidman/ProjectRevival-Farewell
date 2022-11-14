-- The 'nice' name of the faction.
FACTION.name = "Droid"
-- A description used in tooltips in various menus.
FACTION.desc = "A common droid."
FACTION.isGloballyRecognized = true
-- A color to distinguish factions from others, used for stuff such as
-- name color in OOC chat.
FACTION.color = Color(124, 98, 42)

FACTION.isDefault = false

FACTION.models = {
	"models/player/valley/k2so.mdl",
	"models/kingpommes/starwars/misc/droids/gnk_droid.mdl",
	"models/kingpommes/starwars/misc/droids/r5_j2.mdl",
	"models/kingpommes/starwars/misc/droids/mouse_droid.mdl",
	"models/kingpommes/starwars/misc/droids/r2_q5.mdl",
	"models/kingpommes/starwars/misc/droids/r4_i9.mdl",
	"models/starwars/syphadias/ships/probe_droid/probe_droid.mdl",
	"models/kingpommes/starwars/playermodels/mouse.mdl",
	"models/misc/death_star/droid_104th.mdl"
}

-- FACTION.index is defined when the faction is registered and is just a numeric ID.
-- Here, we create a global variable for easier reference to the ID.
FACTION_CIVILIAN = FACTION.index
