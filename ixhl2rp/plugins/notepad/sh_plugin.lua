--[[
	� 2012 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

PLUGIN.name = "Notepad";
PLUGIN.description = "Adds purchasable notepads which players can write/edit.";
PLUGIN.author = "RJ";
PLUGIN.maxLength = 512;
PLUGIN.notepadIDs = {};

ix.util.Include("cl_plugin.lua");
ix.util.Include("sv_plugin.lua");
ix.util.Include("sv_hooks.lua");