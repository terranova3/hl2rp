--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
    without permission of its author (zacharyenriquee@gmail.com).
    
    This content is only intended to be used on the TERRANOVA
    Half-Life 2 Roleplay server. Please respect the developers.
--]]

local CHAR = ix.meta.character

-- Called when we need to a character's mastery. We're using this as a helper 'get' function because it looks better.
function CHAR:GetMastery()
    return self:GetVar("mastery", nil)
end

-- Called when we need to check if a character hs access to a blueprint.
function CHAR:HasBlueprint(uniqueID)
    for _, blueprint in pairs(self:GetVar("blueprints", {})) do
        if(blueprint == uniqueID) then
            return true
        end
    end

    return false
end