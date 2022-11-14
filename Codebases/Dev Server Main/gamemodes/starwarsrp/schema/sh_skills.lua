local skills = {}

skills.slicing = {
    name = "Slicing",
    description = "Your ability to bypass locks to open doors and containers.",
    attribute = "AGI"
}

skills.acrobatics = {
    name = "Acrobatics",
    description = "Your ability to move and jump around effectively, without falling on your face.",
    attribute = {"AGI", "PER"}
}

skills.intimidation = {
    name = "Intimidation",
    description = "How scary you look, and how well you can influence others by looking as scary as you do. Only usable on NPCs",
    attribute = {"STR", "CHR"}
}

skills.bluntweapons = {
    name = "Blunt Weapons",
    description = "Your proficiency with blunt weapons. Maces, riot shields, batons, staves, etc.",
    attribute = "STR"
}

skills.bladedweapons = {
    name = "Bladed Weapons",
    description = "Your proficiency with bladed weapons. Swords, knives, vibroblades, pikes, and lightsabers.",
    attribute = "AGI"
}

ix.skills.Load(skills)