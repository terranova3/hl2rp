--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ix.enterprise = ix.enterprise or {}
ix.enterprise.stored = ix.enterprise.stored or {}

function ix.enterprise.New(character, name, data)
    enterprise = setmetatable({
        owner = character,
        name = name,
    }, ix.meta.enterprise)

    for k, v in pairs(data) do
        enterprise:SetData(k, v)
    end

    local query = mysql:Insert("ix_enterprises")
    query:Insert("owner_id", enterprise.owner)
    query:Insert("name", enterprise.name)
    query:Insert("data", util.TableToJSON(enterprise.data or {}))
    query:Callback(function(_, status, lastID)
        enterprise.id = lastID
    end)
    query:Execute()

    table.insert(ix.enterprise.stored, enterprise)
    ix.enterprise.AddCharacter(enterprise.owner, enterprise.id)
    
    enterprise = nil
end

function ix.enterprise.AddCharacter(charID, id)
    local enterprise = ix.enterprise.stored[id]
    local character = ix.char.loaded[id]

    if(!enterprise) then
        return
    end    

    local query = mysql:Select("ix_characters")
    query:Select("id")
    query:Select("name")
    query:Select("data")
    query:Where("id", charID)
    query:Limit(1)
    query:Callback(function(result)
        if (istable(result) and #result > 0) then
            local characterID = tonumber(result[1].id)
            local data = util.JSONToTable(result[1].data or "[]")
            local name = result[1].name

            data["enterprise"] = id

            local updateQuery = mysql:Update("ix_characters")
                updateQuery:Update("data", util.TableToJSON(data))
                updateQuery:Where("id", characterID)
            updateQuery:Execute()

            enterprise:AddCharacter(characterID)
        end
    end)
    query:Execute()
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

