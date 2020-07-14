--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

function PLUGIN:CanPlayerUseBusiness(client, uniqueID)
	if (client:Team() == FACTION_CITIZEN) then
		local itemTable = ix.item.list[uniqueID]

		if (itemTable) then
			if (itemTable.enterprise) then
				local character = client:GetCharacter()
				local inventory = character:GetInventory()

				if (!character:GetEnterprise()) then
					return false
				end
			end
		end
	end
end