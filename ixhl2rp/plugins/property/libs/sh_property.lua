--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ix.property = {}
ix.property.sections = ix.property.sections or {}
ix.property.stored = {}
ix.property.types = {
	"Residential",
	"Business",
	"Combine"
}

function ix.property:AddSection(type, name, tag)
    if(!ix.property.sections[type]) then
        ix.property.sections[type] = {}
    end

    table.insert(ix.property.sections[type], {
        name = name,
        tag = tag
    })

    PrintTable(ix.property.sections)
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




