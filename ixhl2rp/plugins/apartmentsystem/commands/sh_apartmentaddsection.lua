--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN;

ix.command.Add("ApartmentAddSection", {
	description = "Adds a new apartment section to group and add individual apartments to.",
	superAdminOnly = true,
	arguments = {
		ix.type.string,
		ix.type.string,
		ix.type.string
	},
	OnRun = function(self, client, category, name, prefix)
		if(PLUGIN:GetApartmentCategory(category)) then
			if(!PLUGIN:GetApartmentSection(name)) then 
				PLUGIN:AddApartmentSection(category, name, prefix);
				ix.log.AddRaw(string.format("%s has created a new apartment section named %s, with prefix %s.", client:GetName(), name, prefix));
			else
				return client:NotifyLocalized(string.format("%s already exists.", name));
			end;
		else
			return client:NotifyLocalized(string.format("%s is not a valid category.", category));
		end;
	end
})