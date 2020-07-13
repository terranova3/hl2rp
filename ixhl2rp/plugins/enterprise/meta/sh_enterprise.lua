--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ix.meta = ix.meta or {}

local ENTERPRISE = ix.meta.enterprise or {}
ENTERPRISE.__index = ENTERPRISE
ENTERPRISE.id = 0
ENTERPRISE.owner = 0
ENTERPRISE.name = "undefined"
ENTERPRISE.data = {}
ENTERPRISE.members = {}

function ENTERPRISE:GetName()
    return self.name
end

function ENTERPRISE:GetData(key, default)
    return self.data[key] or default
end

function ENTERPRISE:GetMembers()
    return self.members
end

ix.meta.enterprise = ENTERPRISE
