--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

local PLUGIN = PLUGIN

ix.command.Add("CharSetCPRank", {
    description = "Sets the rank of a civil protection unit.",
    accessLevel = cpSystem.config.commandsAccess["set_cp_rank"],
	arguments = {
		ix.type.character,
		ix.type.string
	},
    OnRun = function(self, client, target, text)
        if(PLUGIN:GetAccessLevel(client:GetCharacter() >= self.accessLevel)) then
            if(PLUGIN:IsMetropolice(target)) then
                if(PLUGIN:RankExists(text)) then
                    client:Notify(string.format("You have set the cp rank of %s to %s.", target:GetName(), text));
                    PLUGIN:SetRank(target, text);
                else
                    client:Notify(string.format("The rank '%s' does not exist.", text));
                end;
            else
                client:Notify(string.format("That character is not a part of the '%s' faction.", target:GetFaction()));
            end;
        else
            client:Notify(string.format("This command requires an access level of %s. Your access level is %s.", self.accessLevel, PLUGIN:GetAccessLevel(client:GetCharacter())));
        end;
	end;
})