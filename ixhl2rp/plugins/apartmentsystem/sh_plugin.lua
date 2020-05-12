--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

PLUGIN.name = "Apartment System";
PLUGIN.description = "Adds keycarded doors and apartment assignment.";
PLUGIN.author = "Adolphus";
PLUGIN.maxLength = 512;

ix.util.Include("sv_hooks.lua");
ix.util.IncludeDirectory(PLUGIN, "config");
ix.util.IncludeDirectory(PLUGIN, "commands");