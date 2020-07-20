--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN

-- Adds an apartment to a section table, includes doors.
function ix.property.Setup(data)
    for k, v in pairs(data.doors) do
        local door = ents.GetMapCreatedEntity(v)

        if(IsValid(door) and door:IsDoor() and !door:GetNetVar("disabled")) then
            if(!data.name) then
                if(ix.property.GetSection(data.section)) then
                    local section = ix.property.GetSection(data.section)

                    door:SetNetVar("name", string.format("%s - Apartment %s", section.tag, ix.property.GetSectionCount(data.section)))
                    door:SetNetVar("visible", true)
                    door:SetNetVar("ownable", nil)
                    door:SetNetVar("property", data.index)
                end
            else
                door:SetNetVar("name", data.name)
                door:SetNetVar("visible", true)
                door:SetNetVar("ownable", nil)
                door:SetNetVar("property", data.index)
            end 
        end
    end

    PLUGIN:SaveProperties()
    ix.doors.Save()
end;