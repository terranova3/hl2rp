--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

cpSystem = {}
cpSystem.config = {}

PLUGIN.name = "Civil Protection System";
PLUGIN.description = "tbd";
PLUGIN.author = "Adolphus";
PLUGIN.maxLength = 512;

-- Core files
ix.util.Include("plugin/sv_plugin.lua");
ix.util.Include("plugin/sv_hooks.lua");
ix.util.Include("plugin/sh_plugin.lua");
ix.util.Include("plugin/cl_hooks.lua");
ix.util.Include("plugin/libs/sh_ranks.lua");
ix.util.Include("plugin/meta/sh_character.lua");
ix.util.Include("plugin/meta/sh_player.lua");

-- Config files
ix.util.Include("config/sv_config.lua");	
ix.util.Include("config/sh_config.lua");	
ix.util.Include("config/cl_config.lua");	