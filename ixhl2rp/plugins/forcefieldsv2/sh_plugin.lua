local PLUGIN = PLUGIN

PLUGIN.name= "Forcefields V2";
PLUGIN.author= "zamboni, _HappyGoLucky";
PLUGIN.description= "Adds forcefields v2 with Clockwork support and persistence.";

ix.util.Include("cl_plugin.lua")
ix.util.Include("sh_hooks.lua")
ix.util.Include("sv_plugin.lua")
ix.util.Include("sv_hooks.lua")
ix.util.IncludeDir(PLUGIN.folder .. "/derma", true)
ix.util.IncludeDir(PLUGIN.folder .. "/commands", true)
