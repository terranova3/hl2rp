--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

PLUGIN.name = "Improved Spawnmenu";
PLUGIN.description = "Adds a new admin spawn menu with a better user interface.";
PLUGIN.author = "Adolphus";

ix.util.Include("sv_plugin.lua")
ix.util.Include("cl_hooks.lua")
ix.util.IncludeDir(PLUGIN.folder .. "/commands", true)