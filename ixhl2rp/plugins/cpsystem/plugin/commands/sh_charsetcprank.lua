--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

local PLUGIN = PLUGIN

ix.command.Add("CharSetCPRank", {
	adminOnly = true, -- TODO: Access based on rank, not admin.
	arguments = {
		ix.type.character,
		ix.type.string
	},
    OnRun = function(self, client, target, text)
        if(PLUGIN:IsMetropolice(target)) then
            if(PLUGIN:RankExists(text)) then
                PLUGIN:SetRank(target, text);
                client:Notify(string.format("You have set the cp rank of %s to %s.", target:GetName(), text));
            else
                client:Notify(string.format("The rank '%s' does not exist.", text));
            end;
        else
            client:Notify(string.format("That character is not a part of the '%s' faction.", target:GetFaction()));
        end;
	end;
})