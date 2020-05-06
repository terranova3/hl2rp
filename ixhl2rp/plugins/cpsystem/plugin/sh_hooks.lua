--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

local Schema = Schema;
local PLUGIN = PLUGIN;

-- called when the client wants to view the combine data for the given target
function Schema:CanPlayerViewData(client, target)
	return client:IsCombine() and (!target:IsCombine() and target:Team() != FACTION_ADMIN)
end

-- called when the client wants to edit the combine data for the given target
function Schema:CanPlayerEditData(client, target)
	return client:IsCombine() and (!target:IsCombine() and target:Team() != FACTION_ADMIN)
end

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