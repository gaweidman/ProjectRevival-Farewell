local PLUGIN = PLUGIN;
PLUGIN.name = 'Garbage';
PLUGIN.author = 'Bilwin';
PLUGIN.description = 'Garbage loot';

GarbageLoot = GarbageLoot or {}
GarbageLoot.config = {
    ["items"] = {
        "items_filename_without_sh_here",
        "items_filename_without_sh_here",
        "items_filename_without_sh_here",
        "items_filename_without_sh_here",
        "items_filename_without_sh_here",
        "items_filename_without_sh_here"
    },
    ["chance"] = 55 -- drop chance
}

-- when you're spawned the entity, you can disable garbage collision for comfort