--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

local PLUGIN = PLUGIN
local characterMeta = ix.meta.character

function characterMeta:IsSmoking()
	if(PLUGIN:IsSmoking(self)) then
		return true
	end
	
	return false
end