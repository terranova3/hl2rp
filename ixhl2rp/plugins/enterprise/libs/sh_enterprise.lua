--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ix.enterprise = ix.enterprise or {}
ix.enterprise.stored = ix.enterprise.stored or {}

function ix.enterprise.New(character, name, description)
    enterprise = setmetatable({
        owner = character,
        name = name,
    }, ix.meta.enterprise)

    enterprise:SetData("description", description)

    local query = mysql:Insert("ix_enterprises")
    query:Insert("owner_id", enterprise.owner)
    query:Insert("name", enterprise.name)
    query:Insert("data", util.TableToJSON(enterprise.data or {}))
    query:Callback(function(_, status, lastID)
        enterprise.id = lastID
    end)
    query:Execute()

    table.insert(ix.enterprise.stored, enterprise)

    PrintTable(ix.enterprise.stored)
    enterprise = nil
end

function ix.enterprise.Load()
	local query = mysql:Select("ix_enterprises")
    query:Callback(function(info)
        if (istable(info) and #info > 0) then
            

        end
    end)
    query:Execute()
end

function ix.enterprise.Delete(name)
    local query = mysql:Delete("ix_enterprises")
    query:Where("character_id", id)
    query:Execute()
end

function ix.enterprise.Get(name)
    for k, v in pairs(ix.enterprise.stored) do
        if(v.name == name) then
            return v
        end
    end
    
    return false
end

