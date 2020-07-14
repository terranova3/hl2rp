--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ix.enterprise = ix.enterprise or {}
ix.enterprise.stored = ix.enterprise.stored or {}

function ix.enterprise.New(client, character, name, data)
    local query = mysql:Select("ix_characters")
    query:Select("id", id)
    query:Select("enterprise", id)
    query:Where("id", character)
    query:Callback(function(results)
        if(istable(results) and #results > 0) then
            if(results[1].enterprise == nil) then
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
                    ix.enterprise.stored[enterprise.id] = enterprise
                    ix.enterprise.AddCharacter(tonumber(enterprise.owner), tonumber(enterprise.id))
                    
                    enterprise = nil
                end)
                query:Execute()
            else
                client:Notify("That character can't create an enterprise since it's already a part of another one!")
            end
        end
    end)
    query:Execute()
end


function ix.enterprise.AddCharacter(charID, id)
    local enterprise = ix.enterprise.stored[id]
    local members = enterprise.members or {}
    local character = ix.char.loaded[charID]

    if(!enterprise) then
        return
    end    

    if(!character) then
        print("went here 33")
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

                    table.insert(members, member) 

                    enterprise.members = members
                end
            end)
        query:Execute()
    else
        print("went here", id)
        character:SetEnterprise(id)

        local member = {
            id = character:GetID(),
            name = character:GetName(),
            model = character:GetModel()
        }

        table.insert(members, member) 

        enterprise.members = members
      
        PrintTable(enterprise)
    end
end

function ix.enterprise.Delete(id)
    local query = mysql:Delete("ix_enterprises")
    query:Where("enterprise_id", id)
    query:Execute()

    ix.enterprise.stored[id] = nil
end

function ix.enterprise.Get(name)
    for k, v in pairs(ix.enterprise.stored) do
        if(v.name == name) then
            return v
        end
    end
    
    return false
end

