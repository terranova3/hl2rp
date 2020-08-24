--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN;

PLUGIN.name = "Character Traits";
PLUGIN.description = "Adds an all encompassing way to describe your character.";
PLUGIN.author = "Adolphus";

ix.util.Include("meta/sh_trait.lua")
ix.util.IncludeDir(PLUGIN.folder .. "/commands", true)

PLUGIN.categories = {
	"physical",
	"intelligence",
	"mentality",
	"philosophy"
}

function PLUGIN:OnLoaded()
	for _, path in ipairs(self.paths or {}) do
		for _, v in pairs(self.categories) do
			ix.traits.LoadFromDir(path.."/traits/" .. v)
		end
	end
end

netstream.Hook("ViewCharTraits", function(target)
	vgui.Create("ixCharTraits"):Build(target)
end)