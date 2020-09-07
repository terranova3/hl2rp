--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

PLUGIN.name = "Viewdata";
PLUGIN.description = "Implements a new viewdata screen to hold records and a note.";
PLUGIN.author = "Adolphus";

-- Globals for viewdata message types to make it neater.
VIEWDATA_ADDROW = 1
VIEWDATA_REMOVEROW = 2
VIEWDATA_EDITROW = 3
VIEWDATA_UPDATEVAR = 4

-- Default viewdata note.
PLUGIN.defaultNote = [[
This is the default note
]]

ix.util.Include("sv_hooks.lua")
ix.util.Include("cl_hooks.lua")
ix.util.IncludeDir(PLUGIN.folder .. "/commands", true)