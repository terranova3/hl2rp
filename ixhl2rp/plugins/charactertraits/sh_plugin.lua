--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN;

PLUGIN.name = "Character Traits";
PLUGIN.description = "Adds an all encompassing way to describe your character.";
PLUGIN.author = "Adolphus";
PLUGIN.categories = {
	"physical",
	"intelligence",
	"mentality",
	"philosophy"
}

ix.util.Include("meta/sh_trait.lua")


function PLUGIN:OnLoaded()
	for _, path in ipairs(self.paths or {}) do
		for _, v in pairs(self.categories) do
			ix.traits.LoadFromDir(path.."/traits/" .. v)
		end
	end
	
	MsgC(Color(25, 235, 25), "[Character Traits] Loaded " .. ix.traits.indices .. " different traits!\n")
end
