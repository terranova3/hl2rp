--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local CHAR = ix.meta.character

function CHAR:IsDonator(value)
    local group = serverguard.player:GetRank(self:GetPlayer())

    if(group == "Donator") then
        return true
    end

    return false
end