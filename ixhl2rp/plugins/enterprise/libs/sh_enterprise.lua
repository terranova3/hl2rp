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
        data = data
    }, ix.meta.enterprise)

    local query = mysql:Insert("ix_enterprises")
    query:Insert("owner_id", enterprise.owner)
    query:Insert("name", enterprise.name)
    query:Insert("data", util.TableToJSON(enterprise.data or {}))
    query:Callback(function(_, status, lastID)
        enterprise.id = lastID
    end)
    query:Execute()

    ix.enterprise.stored[enterprise.id] = enterprise
    ix.enterprise.AddCharacter(enterprise.owner, enterprise.id)
    
    PrintTable(ix.enterprise.stored[enterprise.id])
    enterprise = nil
end

function ix.enterprise.AddCharacter(charID, id)
    local enterprise = ix.enterprise.stored[id]
    local character = ix.char.loaded[charID]

    if(!enterprise) then
        return
    end    

    if(!character) then
        local query = mysql:Select("ix_characters")
            query:Update("enterprise", id)
            query:Where("id", charID)
            query:Limit(1)
        query:Execute()

        local query = mysql:Select("ix_characters")
            query:Select("id")
            query:Select("name")
            query:Select("model")
            query:Where("id", charID)
            query:Callback(function(results)
                if(istable(results) and #results > 0) then
                    local member = {
                        id = member.id,
                        name = member.name,
                        model = member.model
                    }

                    table.insert(enterprise.members, member)
                end
            end)
        query:Execute()

    else
        character:SetEnterprise(id)
        
        local member = {
            id = character:GetID(),
            name = character:GetName(),
            model = character:GetModel()
        }

        table.insert(enterprise.members, member)
    end
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

