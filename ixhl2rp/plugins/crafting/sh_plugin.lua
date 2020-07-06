
local PLUGIN = PLUGIN

PLUGIN.name = "Better Crafting"
PLUGIN.author = "wowm0d"
PLUGIN.description = "Adds a better crafting solution to helix."

ix.util.Include("sh_hooks.lua", "shared")
ix.util.Include("meta/sh_recipe.lua", "shared")
ix.util.Include("meta/sh_station.lua", "shared")
