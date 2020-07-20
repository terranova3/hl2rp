--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]
local PLUGIN = PLUGIN

ix.command.Add("PropertyAddSection", {
	description = "Adds a section for a property type.",
    superAdminOnly = true,
    arguments = {
        ix.type.string,
        ix.type.string,
        ix.type.string
	},
    OnRun = function(self, client, type, section, tag)
        if(ix.property.GetType(type)) then
            ix.property.AddSection(type, section, tag)
            
            client:ChatNotify(string.format("[Property] Created section %s for %s with abbreviation %s.", section, type, tag))           
        else
            local typesString = ""

            for i = 1, #ix.property.types do
                if(i == 1) then
                    typesString = typesString .. ix.property.types[i]
                else 
                    typesString = typesString .. ", " .. ix.property.types[i]
                end
            end

            client:ChatNotify(string.format("[Property] %s does not exist. You can use the following property types: %s", type, typesString))
        end
	end
})