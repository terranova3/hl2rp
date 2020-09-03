--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local CHAR = ix.meta.character

function CHAR:GetKevlar()
    for k, v in pairs(self:GetCharPanel():GetItems()) do
        if(v.outfitCategory == "kevlar") then
            return v
        end
    end

    return nil
end
