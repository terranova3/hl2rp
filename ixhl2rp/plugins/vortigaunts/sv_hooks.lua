--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN;

function PLUGIN:PlayerFootstep(client, position, foot, soundName, volume)
	local factionTable = ix.faction.Get(client:Team());

	if (factionTable.walkSounds) then
		client:EmitSound(factionTable.walkSounds[foot]);
		return true;
	end
end