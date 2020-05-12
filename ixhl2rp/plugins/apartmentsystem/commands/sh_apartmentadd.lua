--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN;

ix.command.Add("ApartmentAdd", {
	description = "Adds an apartment to the system.",
	superAdminOnly = true,
	arguments = {
		ix.type.string
	},
	OnRun = function(self, client, section)
		local data = {}		
		data.start = client:GetShootPos()
		data.endpos = data.start + client:GetAimVector() * 96
		data.filter = client

		local door = util.TraceLine(data).Entity

		if (!IsValid(door) or !door:IsDoor()) then
			return client:NotifyLocalized("dNotValid")
		else
			if(PLUGIN:GetApartmentSection(section)) then
				PLUGIN:AddApartment(section, door)
				ix.log.AddRaw(string.format("%s has created a new apartment in section %s.", client:GetName(), section));
			else
				return client:NotifyLocalized(string.format("%s is not a valid section.", section));
			end;
		end
	end
})