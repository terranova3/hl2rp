--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ix.permits = {}
ix.permits.stored = {}

function ix.permits.Add(name, description, icon)
    if(!name and !description) then
        return
    end

    local permit = {
        name = name,
        description = description,
        icon = icon or string.format("terranova/ui/permits/%s.png", name)
    }

    table.insert(ix.permits.stored, permit)
end

function ix.permits.GetAll()
    return ix.permits.stored
end

function ix.permits.Get(name)
    for k, v in pairs(ix.permits.stored) do
        if(v.name == name) then
            return v
        end
    end

    return false
end