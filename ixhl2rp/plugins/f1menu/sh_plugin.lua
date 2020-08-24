--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

PLUGIN.name = "F1 Menu";
PLUGIN.description = "Displays a character menu when you press F1.";
PLUGIN.author = "Adolphus";

ix.util.Include("cl_hooks.lua")
ix.util.IncludeDir(PLUGIN.folder .. "/commands", true)