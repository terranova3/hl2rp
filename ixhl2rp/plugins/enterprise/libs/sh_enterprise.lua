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
                data["ranks"] = {
                    [1] = {
                        name = "Owner",
                        isOwner = true,
                        isDefault = false
                    },
                    [2] = {
                        name = "Manager",
                        isDefault = false
                    },
                    [3] = {
                        name = "Member",
                        isDefault = true
                    }
                }

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
    local rank

    if(!enterprise) then
        return
    end    

    if(enterprise:GetOwner() == charID) then
        rank = enterprise:GetRanks()[1]
    else
        rank = enterprise:GetDefaultRank()
    end

    -- SetEnterprise will update this, but it doesn't do it instantly, and the data must be done instantly. 
    -- So therefore we do it before the operation updates automatically.
    local query = mysql:Select("ix_characters")
        query:Update("enterprise", id)
        query:Update("enterpriserank", rank)
        query:Where("id", charID)
        query:Limit(1)
    query:Execute()

    if(!character) then
        local query = mysql:Select("ix_characters")
            query:Select("id")
            query:Select("name")
            query:Select("model")
            query:Select("enterpriserank")
            query:Where("id", charID)
            query:Callback(function(results)
                if(istable(results) and #results > 0) then
                    local member = {
                        id = member.id,
                        name = member.name,
                        model = member.model,
                        rank = member.enterpriserank
                    }

                    table.insert(members, member) 

                    enterprise.members = members
                end
            end)
        query:Execute()
    else
        character:SetEnterprise(id)
        character:SetEnterpriseRank(rank)

        local member = {
            id = character:GetID(),
            name = character:GetName(),
            model = character:GetModel(),
            rank = character:GetEnterpriseRank()
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

