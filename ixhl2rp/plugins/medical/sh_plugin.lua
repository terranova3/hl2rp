--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

PLUGIN.name = "Medical";
PLUGIN.description = "Needs a description.";
PLUGIN.author = "Heyter, Adolphus";

ix.util.IncludeDir(PLUGIN.folder .. "/config", true);
ix.util.IncludeDir(PLUGIN.folder .. "/meta", true);
ix.util.Include("sv_hooks.lua")