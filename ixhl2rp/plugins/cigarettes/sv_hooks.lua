--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

local PLUGIN = PLUGIN

-- Returns if the character has a cigarette that he is smoking and is lit.
function PLUGIN:IsSmoking(character)
    for k, v in pairs(character:GetInventory():GetItems()) do
        if(v.base = "cigarettes" and v:IsSmoking() and v:IsLit()) then
            return true
        end
    end

    return false
end

-- Called when we need start doing smoking behaviour and we need to initalise the tick.
function PLUGIN:StartSmoking(character, item)
    local smokeTick = string.format("%s%s", "SmokeTick", character:GetID())

    if(timer.Exists(smokeTick) then
        timer.Destroy(smokeTick)
    end

    timer.Create(smokeTick, 1, 0, function()
        print("tick!")
    end)
end