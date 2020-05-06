--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

local PLUGIN = PLUGIN

ix.command.Add("CharGetCPAccessLevel", {
    description = "Gets the access level of a civil protection unit.",
    accessLevel = cpSystem.config.commandsAccess["get_cp_access_level"],
	arguments = {
		ix.type.character
	},
    OnRun = function(self, client, target)
        if(PLUGIN:GetAccessLevel(client:GetCharacter() >= self.accessLevel) then
            if(PLUGIN:IsMetropolice(target)) then
                if(PLUGIN:RankExists(target:GetData("cpRank"))) then
                    client:Notify(string.format("The access level of %s is %s.", target:GetName(), PLUGIN:GetAccessLevel(target)));
                else
                    client:Notify(string.format("The access level of %s could not be found. This is because they do not have a valid rank, possibly because their name has been manually changed.", target:GetName() ));
                end;
            else
                client:Notify(string.format("That character is not a part of the '%s' faction.", target:GetFaction()));
            end;
        else
            client:Notify(string.format("This command requires an access level of %s. Your access level is %s.", self.accessLevel, PLUGIN:GetAccessLevel(client:GetCharacter())));
        end;
	end;
})