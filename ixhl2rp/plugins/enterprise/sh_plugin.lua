--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

PLUGIN.name = "Enterprises";
PLUGIN.description = "Needs a description.";
PLUGIN.author = "Adolphus";

ix.util.IncludeDir(PLUGIN.folder .. "/meta", true)
ix.util.Include("sh_permits.lua")
ix.util.Include("sv_database.lua")
ix.util.Include("sv_hooks.lua")
ix.util.Include("sh_hooks.lua")
ix.util.Include("cl_hooks.lua")