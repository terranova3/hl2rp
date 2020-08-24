--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
    without permission of its author (zacharyenriquee@gmail.com).
    
    This content is only intended to be used on the TERRANOVA
    Half-Life 2 Roleplay server. Please respect the developers.
--]]

local CHAR = ix.meta.character

function CHAR:GetJob()
    local inventory = self:GetInventory()

    for k, v in pairs(inventory:GetItems()) do
        if(v.uniqueID == "cid" and v:GetData("cid") == self:GetData("cid", 0)) then
            return v:GetData("employment")
        end
    end

    return nil
end

function CHAR:GetWage()
    local inventory = self:GetInventory()

    for k, v in pairs(inventory:GetItems()) do
        if(v.uniqueID == "cid" and v:GetData("cid") == self:GetData("cid", 0)) then
            return v:GetData("salary")
        end
    end

    return nil
end