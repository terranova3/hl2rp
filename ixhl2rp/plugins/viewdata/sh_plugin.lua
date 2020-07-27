--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

PLUGIN.name = "Viewdata";
PLUGIN.description = "tbd";
PLUGIN.author = "Adolphus";
PLUGIN.message = {
	ADDROW = PLUGIN.AddRow,
	REMOVEROW = PLUGIN.RemoveRow,
	EDITROW = PLUGIN.EditRow,
	UPDATEVAR = PLUGIN.UpdateVar
}

ix.util.Include("sv_hooks.lua")
ix.util.Include("cl_hooks.lua")
ix.util.IncludeDir(PLUGIN.folder .. "/commands", true)