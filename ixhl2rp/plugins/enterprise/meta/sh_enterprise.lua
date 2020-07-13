--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ix.meta = ix.meta or {}

local ENTERPRISE = ix.meta.trait or {}
ENTERPRISE.__index = ENTERPRISE
ENTERPRISE.id = 0
ENTERPRISE.owner = 0
ENTERPRISE.name = "undefined"
ENTERPRISE.data = {}
ENTERPRISE.characters = {}

function ENTERPRISE:AddCharacter(id)
    table.insert(self.characters, id)
end

function ENTERPRISE:SetData(key, value)
    self.data[key] = value
end

function ENTERPRISE:GetData(key, default)
    return self.data[key] or default
end

ix.meta.enterprise = ENTERPRISE
