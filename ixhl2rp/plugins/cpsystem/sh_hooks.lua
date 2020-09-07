--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

local Schema = Schema;
local PLUGIN = PLUGIN;

-- Called when the client wants to view the combine data for the given target
function Schema:CanPlayerViewData(client, target)
	return (client:IsCombine() or client:Team() == FACTION_ADMIN) and (target:Team() != FACTION_ADMIN)
end

-- Called when the client wants to edit the combine data for the given target
function Schema:CanPlayerEditData(client, target)
	return client:IsCombine() and (!target:IsCombine() and target:Team() != FACTION_ADMIN)
end

-- Called when a client has run the command to edit combine objectives.
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

function PLUGIN:PlayerTick(player)
	if player:IsCombine() and player:Alive() then
		if !player.nextTrivia or player.nextTrivia <= CurTime() then
			Schema:AddCombineDisplayMessage(table.Random(cpSystem.config.displayMessages), Color(255,255,255,255))
			player.nextTrivia = CurTime() + 8
		end
	end
end

-- Called when the client is checking if it has access to see the character panel
function PLUGIN:CharPanelCanUse(client)
	if (client:IsCombine()) then
		return false
	end
end;