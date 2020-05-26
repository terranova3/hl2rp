--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

PLUGIN.name = "Apartment System";
PLUGIN.description = "Adds keycarded doors and apartment assignment.";
PLUGIN.author = "Adolphus";

ix.util.Include("sv_hooks.lua");
ix.util.IncludeDir(PLUGIN.folder .. "/config", true);
ix.util.IncludeDir(PLUGIN.folder .. "/commands", true);