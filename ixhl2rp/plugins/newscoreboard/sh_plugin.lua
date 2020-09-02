--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

PLUGIN.name = "New Scoreboard";
PLUGIN.description = "Updates the scoreboard to have custom class functionality";
PLUGIN.author = "Adolphus";

local PLUGIN = PLUGIN

if(CLIENT) then
	function PLUGIN:ShouldShowOnScoreboard(target)
		local faction = ix.faction.Get(target:Team())

		if(faction and faction.HideOnScoreboard and faction != ix.faction.Get(LocalPlayer():Team())) then
			return false
		end

		return true
	end
end