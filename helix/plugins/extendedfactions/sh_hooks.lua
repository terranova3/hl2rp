--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN

function PLUGIN:OnCharacterCreated(client, character)
    local faction = character:GetFaction()

    if(ix.ranks.GetFactionRanks(faction)) then
        character:SetData("rank", ix.ranks.GetDefaultRank(faction));
    end
end