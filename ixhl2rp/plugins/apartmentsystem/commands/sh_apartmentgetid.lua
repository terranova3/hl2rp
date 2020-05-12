--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN;

ix.command.Add("ApartmentGetID", {
	description = "Look at an apartment door and run this command to get it's uniqueID.",
	superAdminOnly = true,
	OnRun = function(self, client)
		local data = {}		
		data.start = client:GetShootPos()
		data.endpos = data.start + client:GetAimVector() * 96
		data.filter = client

		local door = util.TraceLine(data).Entity

		if (!IsValid(door) or !door:IsDoor()) then
			return client:NotifyLocalized("dNotValid")
		else
			if(door.apartmentID) then
				return client:NotifyLocalized(string.format("That apartment has a uniqueID of %s.", door.apartmentID));
			else
				return client:NotifyLocalized("That is not an apartment door or has not been hooked up yet!");
			end;
		end
	end
})