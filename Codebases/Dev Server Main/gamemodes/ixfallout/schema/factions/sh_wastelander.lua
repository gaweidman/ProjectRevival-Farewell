FACTION.name = "Wastelander"
FACTION.description = "A post-apocalyptic survivor, roaming the wastes of California."
FACTION.isDefault = true
FACTION.color = Color(100, 60, 60)

-- You should define a global variable for this faction's index for easy access wherever you need. FACTION.index is
-- automatically set, so you can simply assign the value.

-- Note that the player's team will also have the same value as their current character's faction index. This means you can use
-- client:Team() == FACTION_CITIZEN to compare the faction of the player's current character.
FACTION_WASTELANDER = FACTION.index