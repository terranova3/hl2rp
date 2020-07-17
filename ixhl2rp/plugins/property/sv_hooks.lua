--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN

util.AddNetworkString("ixPropertyAddSync")
util.AddNetworkString("ixPropertyAddDerma")

function PLUGIN:KeyPress(client, key)
	if (key == IN_RELOAD) then
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96
			data.filter = client
		local entity = util.TraceLine(data).Entity

		if (IsValid(entity) and entity:IsDoor()) then
			client.selectedDoors = client.selectedDoors or {}
			local add = true

			for k, v in pairs(client.selectedDoors) do
				if(v == entity) then
					table.RemoveByValue(client.selectedDoors, entity)
					add = false

					break
				end
			end

			if(add) then
				table.insert(client.selectedDoors, entity)
			end

			PrintTable(client.selectedDoors)

			net.Start("ixPropertyAddSync")
				net.WriteTable(client.selectedDoors)
			net.Send(client)
		end
	end
end