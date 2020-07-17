--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

PLUGIN.name = "Property";
PLUGIN.description = "Extends the base door system and allows for staff to add doors to property blocks.";
PLUGIN.author = "Adolphus";

local PLUGIN = PLUGIN

ix.util.Include("sv_hooks.lua")
ix.util.Include("cl_hooks.lua")
ix.util.IncludeDir(PLUGIN.folder .. "/commands", true)