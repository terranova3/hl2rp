--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

PLUGIN.name = "Cigarettes";
PLUGIN.description = "Adds smokable cigarettes.";
PLUGIN.author = "Adolphus";

local PLUGIN = PLUGIN
PLUGIN.pacData = PLUGIN.pacData or {}

ix.util.Include("sv_hooks.lua")
ix.util.IncludeDir(PLUGIN.folder .. "/meta", true)
ix.util.IncludeDir(PLUGIN.folder .. "/pacdata", true)