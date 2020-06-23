--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN

function PLUGIN:PlayerLoadedCharacter(client, character)
	character:SetupRankBodygroups()
end