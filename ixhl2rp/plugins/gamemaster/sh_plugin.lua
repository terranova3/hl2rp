--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

PLUGIN.name = "Gamemaster";
PLUGIN.description = "Adds a gamemaster staff role with tools to enhance roleplay experience for players.";
PLUGIN.author = "Adolphus";

ix.util.Include("cl_hooks.lua")

CAMI.RegisterPrivilege({
	Name = "Helix - Gamemaster",
	MinAccess = "superadmin"
})
