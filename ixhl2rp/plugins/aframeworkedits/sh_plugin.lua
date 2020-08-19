--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

PLUGIN.name = "Framework edits";
PLUGIN.description = "Various miscellaneous framework edits placed into a plugin.";
PLUGIN.author = "TERRANOVA";

ix.util.Include("sv_hooks.lua")
ix.util.Include("cl_hooks.lua")
ix.util.Include("cl_fonts.lua")
ix.util.IncludeDir(PLUGIN.folder .. "/commands", true)

-- Look Range/Distance
ix.config.Add("LookRange", 160, "The distance in which you can see stuff. Default 160.", nil, {
	category = "Interaction",
	data = { min = 100, max = 1600 }
})
