--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

local PLUGIN = PLUGIN
local characterMeta = ix.meta.character

function characterMeta:CigaretteEquipped()
    for k, v in pairs(self:GetInventory():GetItems()) do
        if(v.Light and v:GetData("equip", false) == true) then
            return true
        end
    end

    return false
end

function characterMeta:IsSmoking()
	if(PLUGIN:IsSmoking(self)) then
		return true
	end
	
	return false
end