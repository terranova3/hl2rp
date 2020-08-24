--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

PLUGIN.name = "Integration";
PLUGIN.description = "Handles connecting discord, forum and steam accounts together ingame.";
PLUGIN.author = "Adolphus";

ix.util.IncludeDir(PLUGIN.folder .. "/meta", true)
ix.util.Include("sv_hooks.lua")