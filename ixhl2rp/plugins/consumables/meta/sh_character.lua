--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local CHAR = ix.meta.character
local PLUGIN = PLUGIN

function CHAR:AddHealing(value)
    PLUGIN:AddHealing(self, value)
end