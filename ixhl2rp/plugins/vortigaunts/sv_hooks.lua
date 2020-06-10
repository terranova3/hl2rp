--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN;

function PLUGIN:PlayerFootstep(client, position, foot, soundName, volume)
	local factionTable = ix.faction.Get(client:Team());
	local character = client:GetCharacter();

	if (factionTable.walkSounds) then
		client:EmitSound(factionTable.walkSounds[foot]);
		return true;
	end
end

-- Called when the client is checking if it has access to see the character panel
function PLUGIN:CharPanelShouldShow(client)
	local faction = client:GetCharacter():GetFaction()

	if(faction == FACTION_VORT or faction == FACTION_VORTSLAVE) then
		return false
	end
end;
