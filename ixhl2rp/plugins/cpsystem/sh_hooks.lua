--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

local Schema = Schema;
local PLUGIN = PLUGIN;

-- Called when the client wants to view the combine data for the given target
function Schema:CanPlayerViewData(client, target)
	return client:IsCombine() and (!target:IsCombine() and target:Team() != FACTION_ADMIN)
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

	if(PLUGIN:GetAccessLevel(client:GetCharacter()) >= cpSystem.config.commandsAccess["edit_viewobjectives"]) then
		return true;
	else
		return false;
	end;
end

-- Returns if a character is a part of the MPF faction.
function PLUGIN:IsMetropolice(character)
    if(character:GetFaction() == FACTION_MPF) then
        return true;
    else
        return false;
    end;
end;

function PLUGIN:PlayerTick(player)
	if player:IsCombine() and player:Alive() then
		if !player.nextTrivia or player.nextTrivia <= CurTime() then
			Schema:AddCombineDisplayMessage(table.Random(cpSystem.config.displayMessages), Color(255,255,255,255))
			player.nextTrivia = CurTime() + 8
		end
	end
end
