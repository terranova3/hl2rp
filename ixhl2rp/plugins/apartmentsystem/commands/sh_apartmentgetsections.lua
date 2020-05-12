--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN;

ix.command.Add("ApartmentGetSections", {
	description = "Returns a list of sections you can use for apartments.",
	superAdminOnly = true,
	OnRun = function(self, client)
		if(PLUGIN.sections) then
			local sectionNames = "There are the following sections:";

			for i = 1, #PLUGIN.sections do
				sectionNames = sectionNames .. " " .. PLUGIN.sections[i].name;
			end;
			
			return client:NotifyLocalized(sectionNames);
		end
	end
})