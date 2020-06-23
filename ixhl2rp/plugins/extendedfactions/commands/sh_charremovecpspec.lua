--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

local PLUGIN = PLUGIN

ix.command.Add("CharRemoveCPSpec", {
    description = "Removes a certification specialization from a civil protection unit.",
    accessLevel = cpSystem.config.commandsAccess["remove_cp_spec"],
	arguments = {
		ix.type.character
	},
    OnRun = function(self, client, target)
        if(PLUGIN:GetAccessLevel(client:GetCharacter()) >= self.accessLevel) then
            if(PLUGIN:IsMetropolice(target)) then
                target:SetData("spec", nil)

                PLUGIN:UpdateCharacter(target)

                client:Notify(string.format("You have removed the certification specialization from %s.", target:GetName()));
            else
                client:Notify(string.format("That character is not a part of the '%s' faction.", target:GetFaction()));
            end;
        else
            client:Notify(string.format("This command requires an access level of %s. Your access level is %s.", self.accessLevel, PLUGIN:GetAccessLevel(client:GetCharacter())));
        end;
	end;
})