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

function ENTERPRISE:GetOwner()
    return self.owner
end

function ENTERPRISE:GetRanks()
    if(self.data["ranks"]) then
        return self.data["ranks"]
    end

    return nil
end

function ENTERPRISE:GetDefaultRank()
    local lastRank

    for k, v in pairs(self.data["ranks"]) do
        lastRank = k

        if(v.isDefault) then
            return k
        end
    end

    return lastRank or nil
end

function ENTERPRISE:GetRank(rank)
    for k, v in pairs(self.data["ranks"]) do
        if(v.name == rank) then
            return v
        end
    end

    return false
end

ix.meta.enterprise = ENTERPRISE
