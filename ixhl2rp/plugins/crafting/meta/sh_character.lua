--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
    without permission of its author (zacharyenriquee@gmail.com).
    
    This content is only intended to be used on the TERRANOVA
    Half-Life 2 Roleplay server. Please respect the developers.
--]]

local CHAR = ix.meta.character

-- Called when we need to a character's mastery. We're using this as a helper 'get' function because it looks better.
function CHAR:GetMastery()
    return self:GetData("mastery", nil)
end

-- Called when we need to check if a character hs access to a blueprint.
function CHAR:HasBlueprint(uniqueID)
    for _, blueprint in pairs(self:GetData("blueprints", {})) do
        if(blueprint == uniqueID) then
            return true
        end
    end

    return false
end

-- Called when we need to check if a player has a tool.
function CHAR:HasTool(item)
    local inventory = self:GetInventory()

    if(inventory:HasItem(item.uniqueID)) then
        return true
    end

    return false
end

-- Returns if a character is near an entity.
function CHAR:IsNearEnt(uniqueID)
	for _, v in pairs(ents.FindByClass("ix_station_" .. uniqueID)) do
		if (self:GetPlayer():GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, "You need to be near a workbench."
end