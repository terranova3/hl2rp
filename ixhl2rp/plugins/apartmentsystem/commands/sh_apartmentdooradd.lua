--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN;

ix.command.Add("ApartmentDoorAdd", {
	description = "Adds a door to an already existing apartment.",
	superAdminOnly = true,
	arguments = {
		ix.type.number
	},
	OnRun = function(self, client, id)
		local data = {}		
		data.start = client:GetShootPos()
		data.endpos = data.start + client:GetAimVector() * 96
		data.filter = client

		local door = util.TraceLine(data).Entity

		if (!IsValid(door) or !door:IsDoor()) then
			return client:NotifyLocalized("dNotValid")
        elseif(!door.apartmentID) then
            local apartment = PLUGIN:GetApartment(id);

            if(apartment) then
                PLUGIN:AddApartmentDoor(id, door);
			else
				return client:NotifyLocalized(string.format("%s is not a valid apartment id.", id));
            end;
        else
            return client:NotifyLocalized("That is already a part of another apartment.");
		end
	end
})