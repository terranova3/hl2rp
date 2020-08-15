--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
    without permission of its author (zacharyenriquee@gmail.com).
    
    This content is only intended to be used on the TERRANOVA
    Half-Life 2 Roleplay server. Please respect the developers.
--]]

PLUGIN.name = "Crafting"
PLUGIN.description = "Description has not been completed yet."
PLUGIN.author = "Adolphus & Ayreborne"
PLUGIN.recipes = {}

ix.util.IncludeFolder(PLUGIN, "meta")
ix.util.Include("sv_hooks.lua")

function PLUGIN:OnLoaded()
	for _, path in ipairs(self.paths or {}) do
		ix.professions.LoadFromDir(path.."/professions/")
		ix.recipe.LoadFromDir(path.."/professions/")
	end
end