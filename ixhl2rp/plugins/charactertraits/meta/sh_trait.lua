--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ix.meta = ix.meta or {}

local TRAIT = ix.meta.trait or {}
TRAIT.__index = RECIPE
TRAIT.name = "undefined"
TRAIT.description = "undefined"
TRAIT.uniqueID = "undefined"
TRAIT.category = "undefined"
TRAIT.icon = "undefined"
TRAIT.opposite = "undefined"
TRAIT.hooks = {}

function TRAIT:GetName()
	return self.name
end

function TRAIT:GetDescription()
	return self.description
end

function TRAIT:GetIcon()
	return self.icon
end

function TRAIT:AddHook(name, func)
	self.hooks[name] = func
end

ix.meta.trait = TRAIT
