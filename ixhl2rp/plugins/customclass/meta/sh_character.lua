--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

local character = ix.meta.character

function character:GetClassName()
    return ix.class.list[self:GetClass()].name or "Error"
end

function character:GetClassColor()
    return ix.class.list[self:GetClass()].color or team.GetColor(character:GetPlayer():Team())
end 