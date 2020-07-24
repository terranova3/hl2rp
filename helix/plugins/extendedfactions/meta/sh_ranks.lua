--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]


ix.meta = ix.meta or {}

local RANK = ix.meta.rank or {}
RANK.__index = RANK
RANK.name = "undefined"
RANK.displayName = "undefined"
RANK.description = "undefined"
RANK.uniqueID = "undefined"
RANK.bodygroups = {}
RANK.permissions = {}
RANK.order = nil
RANK.isDefault = false
RANK.faction = nil
RANK.overrideBodygroup = false

function RANK:GetName()
	return self.name
end

function RANK:GetDisplayName()
	return self.name
end

ix.meta.rank = RANK
