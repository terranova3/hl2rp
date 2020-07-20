--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN

-- Adds an apartment to a section table, includes doors.
function ix.property.Setup(data)
    for k, v in pairs(data.doors) do
        if(IsValid(v) and v:IsDoor() and !v:GetNetVar("disabled")) then
            if(!data.name) then
                if(ix.property.GetSection(data.section)) then
                    local section = ix.property.GetSection(data.section)

                    v:SetNetVar("name", string.format("%s - Apartment %s", section.tag, ix.property.GetSectionCount(data.section)))
                    v:SetNetVar("visible", true)
                    v:SetNetVar("ownable", nil)
                    v:SetNetVar("property", data.index)
                end
            else
                -- do naming
            end 
        end
    end

    PrintTable(ix.property.stored)
    PLUGIN:SaveProperties()
end;