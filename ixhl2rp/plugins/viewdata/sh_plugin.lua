--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

PLUGIN.name = "Viewdata";
PLUGIN.description = "tbd";
PLUGIN.author = "Adolphus";
PLUGIN.message = {
	ADDROW = 1,
	REMOVEROW = 2,
	EDITROW = 3,
	UPDATEVAR = 4
}
PLUGIN.methods = {
	PLUGIN.AddRow,
	PLUGIN.RemoveRow,
	PLUGIN.EditRow,
	PLUGIN.UpdateVar
}
PLUGIN.defaultNote = [[
This is the default note
]]

ix.util.Include("sv_hooks.lua")
ix.util.Include("cl_hooks.lua")
ix.util.IncludeDir(PLUGIN.folder .. "/commands", true)