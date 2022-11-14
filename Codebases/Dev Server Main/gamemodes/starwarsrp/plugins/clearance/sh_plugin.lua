local PLUGIN = PLUGIN

PLUGIN.name = "Clearance"
PLUGIN.author = "QIncarnate"
PLUGIN.description = "An all-encompassing system for ID Cards and clearances for door opening."

ix.util.Include("cl_plugin.lua")
ix.util.Include("cl_hooks.lua")
ix.util.Include("sh_commands.lua")
ix.util.Include("sv_plugin.lua")
ix.util.Include("sv_hooks.lua")

ix.util.Include("meta/sh_entity.lua")

ix.config.Add("cardSwipeCooldown", 3, "The amount of time a message on the keypad is displayed for.", nil, {
    type = ix.type.number,
    data = {min = 0.1, max = 3},
    category = "Clearance",
    name = "Card Swipe Cooldown"
})

do
    MODE_SWIPE_CARD = {
        ["enum"] = 1, 
        ["msg"] = "Swipe\nCard", 
        ["color"] = Color(255, 255, 255)
    }

    MODE_ACCESS_GRANTED = {
        ["enum"] = 2, 
        ["msg"] = "Access\nGranted", 
        ["color"] = Color(40, 255, 40)
    }

    MODE_ACCESS_DENIED = {
        ["enum"] = 3, 
        ["msg"] = "Access\nDenied", 
        ["color"] = Color(255, 40, 40)
    }

    MODE_OPEN = {
        ["enum"] = 4, 
        ["msg"] = "Open", 
        ["color"] = Color(40, 255, 40)
    }

    MODE_LOCKDOWN = {
        ["enum"] = 5, 
        ["msg"] = "Locked\nDown", 
        ["color"] = Color(255, 40, 40)
    }

    MODE_UNDEFINED = {
        ["enum"] = 6, 
        ["msg"] = "UNDEFINED", 
        ["color"] = Color(255, 40, 255)
    }
end