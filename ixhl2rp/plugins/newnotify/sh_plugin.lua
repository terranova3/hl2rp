--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

PLUGIN.name = "New Notify";
PLUGIN.description = "Adds a new notify for the framework.";
PLUGIN.author = "Adolphus";

-- Global table so we can access this plugin outside of itself.
ix.notify = {}

ix.util.Include("sv_hooks.lua")