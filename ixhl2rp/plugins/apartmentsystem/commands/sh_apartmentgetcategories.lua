--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN;

ix.command.Add("ApartmentGetCategories", {
	description = "Returns a list of categories you can use for apartments.",
	superAdminOnly = true,
	OnRun = function(self, client)
		if(PLUGIN.categories) then
			local categoryNames = "There are the following categories:";

			for i = 1, #PLUGIN.categories do
				categoryNames = categoryNames .. " " .. PLUGIN.categories[i].name;
			end;
			
			return client:NotifyLocalized(categoryNames);
		end
	end
})