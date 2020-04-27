--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

cpSystem = {}
cpSystem.config = {}

PLUGIN.name = "Civil Protection System";
PLUGIN.description = "tbd";
PLUGIN.author = "TERRANOVA";
PLUGIN.maxLength = 512;

-- Core files
ix.util.Include("plugin/sv_hooks.lua");
ix.util.include("plugin/sh_plugin.lua");
ix.util.Include("plugin/cl_hooks.lua");
ix.util.Include("plugin/libs/sh_ranks.lua");
ix.util.Include("plugin/meta/sh_character.lua");

-- Config files
ix.util.include("config/sv_config.lua");	
ix.util.include("config/sh_config.lua");	
ix.util.include("config/cl_config.lua");	