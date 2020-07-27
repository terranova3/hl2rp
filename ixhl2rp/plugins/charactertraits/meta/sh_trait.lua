--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ix.meta = ix.meta or {}

local TRAIT = ix.meta.trait or {}
TRAIT.__index = TRAIT
TRAIT.name = "undefined"
TRAIT.description = "undefined"
TRAIT.uniqueID = "undefined"
TRAIT.category = "undefined"
TRAIT.icon = "undefined"
TRAIT.opposite = "undefined"
TRAIT.negative = false
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

function TRAIT:Register()
	if(self.positive == true) then
		self.order = 1
	elseif(self.negative == true) then
		self.order = 3
	else
		self.order = 2
	end
end

function TRAIT:GetColor()
	if(self.positive == true) then
		return Color(0, 255, 0, 11)
	elseif(self.negative == true) then
		return Color(255, 0, 0, 11)
	else
		return Color(255, 255, 255, 11)
	end
end

ix.meta.trait = TRAIT
