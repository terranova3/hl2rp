--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

local PLUGIN = PLUGIN;

function PLUGIN:SetRank(client, rank)
    if(client:IsMetropolice()) then
        local rankTable = Schema.ranks.Get(rank);

        if(rankTable) then
            client:GetCharacter():SetData("cpRank", rank.text);
            client:GetCharacter():SetData("cpAccessLevel", rank.access)
        end;
    end;
end;

function PLUGIN:GetAccessLevel(client)
    if(client:IsMetropolice()) then
        return client:GetCharacter():GetData("cpAccessLevel");
    end;
end;