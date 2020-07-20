--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

PLUGIN.name = "Extended Factions";
PLUGIN.description = "Adds global features for factions such as ranks, certifications and permission systems.";
PLUGIN.author = "Adolphus";

ix.util.Include("sh_hooks.lua")
ix.util.Include("sv_hooks.lua")
ix.util.IncludeDir(PLUGIN.folder .. "/commands", true)
ix.util.IncludeDir(PLUGIN.folder .. "/meta", true)