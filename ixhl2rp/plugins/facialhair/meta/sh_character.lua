--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
    without permission of its author (zacharyenriquee@gmail.com).
    
    This content is only intended to be used on the TERRANOVA
    Half-Life 2 Roleplay server. Please respect the developers.
--]]

local CHAR = ix.meta.character

function CHAR:IsWearingUniform()
    local inventory = self:GetInventory()

    for k, v in pairs(inventory:GetItems()) do
        if(v.outfitCategory and v:GetData("equip")) then
            return true
        end
    end

    return false
end