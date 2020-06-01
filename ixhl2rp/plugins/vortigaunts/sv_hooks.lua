--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN;

function PLUGIN:PostPlayerLoadout(client)
	if (client:GetFaction() == FACTION_VORT) then
		client:Give("ix_vortibeam")
		client:Give("ix_nightvision");
		client:Give("ix_vortheal");	
	elseif(client:GetFaction() == FACTION_VORTSLAVE) then
		client:Give("ix_broom");
	end;
end