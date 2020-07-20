--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN

ix.property = {}
ix.property.sections = {}
ix.property.stored = {}
ix.property.types = {
	"Residential",
	"Business"
}

-- Instead of using cache for every LUA autorefresh, reload the files.
if(SERVER) then
    PLUGIN:LoadProperties()
end

-- Add a new property to the property table and update it's doors.
function ix.property.Add(data)
    local index = #ix.property.stored+1
    
    data.index = index
    table.insert(ix.property.stored, data)

    ix.property.Setup(data)
end

-- Add a section to the section table
function ix.property.AddSection(type, name, tag)
    if(!ix.property.sections[type]) then
        ix.property.sections[type] = {}
    end

    table.insert(ix.property.sections[type], {
        name = name,
        tag = tag,
        count = 0
    })

    PLUGIN:SaveProperties()
end

function ix.property.GetSection(name)
    if(!name) then
        return
    end

    for _, type in pairs(ix.property.types) do
        if(ix.property.sections[type]) then 
            for _, v in pairs(ix.property.sections[type]) do
                if(v.name == name) then
                    return v
                end
            end
        end
    end

    return nil
end

function ix.property.GetSectionCount(name)
    local count = 0

    for k, v in pairs(ix.property.stored) do
        if(v.section and v.section == name) then
            count = count + 1
        end
    end

    return count
end

function ix.property.GetTypeSections(type)
    if(ix.property.sections[type]) then
        return ix.property.sections[type]
    end
    
    return false
end

function ix.property.GetType(type)
    for k, v in pairs(ix.property.types) do
        if(type:lower() == v:lower()) then
            return true
        end
    end

    return false
end