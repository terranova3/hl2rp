--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local CHAR = ix.meta.character

function CHAR:GetLimbs()
    return self:GetData("limbs", {})
end

function CHAR:SetLimbs(data)
    self:SetData("limbs", data)
end