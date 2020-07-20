--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN

util.AddNetworkString("ixPropertyAddSync")
util.AddNetworkString("ixPropertyAddDerma")
util.AddNetworkString("ixPropertyNew")

net.Receive("ixPropertyNew", function(length, client)
	local property = net.ReadTable()

	if(!client or !client:IsAdmin()) then
		return
	end

	client:SetData("propertyEdit", false)
	client.selectedDoors = {}
	
	ix.property.Add(property)
end)

function PLUGIN:SaveData()
	self:SaveProperties()
end

function PLUGIN:LoadData()
	self:LoadProperties()
end

function PLUGIN:SaveProperties()
	local data = {
		sections = ix.property.sections or {},
		properties = ix.property.stored or {}
	}

	ix.data.Set("properties", data)
end

function PLUGIN:LoadProperties()
	local data = ix.data.Get("properties")

	if(data) then
		ix.property.sections = data.sections or {}
		ix.property.stored = data.properties or {}

		PrintTable(ix.property.sections)
		PrintTable(ix.property.stored)
	end
end


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