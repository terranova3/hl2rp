--[[ This is used for the permits.
function Schema:CanPlayerUseBusiness(client, uniqueID)
	if (client:Team() == FACTION_CITIZEN) then
		local itemTable = ix.item.list[uniqueID]

		if (itemTable) then
			if (itemTable.permit) then
				local character = client:GetCharacter()
				local inventory = character:GetInventory()

				if (!inventory:HasItem("permit_"..itemTable.permit)) then
					return false
				end
			elseif (itemTable.base ~= "base_permit") then
				return false
			end
		end
	end
end--]]

function Schema:CanPlayerViewObjectives(client)
	return client:IsCombine() or client:Team() == FACTION_ADMIN
end

function Schema:CanPlayerEditObjectives(client)
	if (!client:IsCombine() or !client:GetCharacter()) then
		return false
	end

	local character = client:GetCharacter()
	local bCanEdit = false
	
	if(character:GetRank() and ix.ranks.HasPermission(character:GetRank().uniqueID, "Edit viewobjectives")) then
		bCanEdit = true
	end

	return bCanEdit
end

function Schema:CanDrive()
	return false
end
