local PLUGIN = PLUGIN

PLUGIN.name = "Advanced Drugs"
PLUGIN.author = "Madeon"
PLUGIN.description = "Adds a advanced drug system, with multiple drugs and effects."

ix.char.RegisterVar("drugTimer", {
	field = "drugTimer",
	fieldType = ix.type.number,
	default = 100,
	isLocal = true,
	bNoDisplay = true
})

ix.char.RegisterVar("drug", {
    field = "drug",
    default = "",
    isLocal = true,
    bNoDisplay = true
})

ix.util.Include("cl_hooks.lua")
ix.util.Include("sv_hooks.lua")