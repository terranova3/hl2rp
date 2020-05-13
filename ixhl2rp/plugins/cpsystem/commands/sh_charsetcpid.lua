--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

local PLUGIN = PLUGIN

ix.command.Add("CharSetCPID", {
    description = "Sets the id of a civil protection unit.",
    accessLevel = cpSystem.config.commandsAccess["set_cp_id"],
	arguments = {
		ix.type.character,
		ix.type.number
	},
    OnRun = function(self, client, target, text)
        if(PLUGIN:GetAccessLevel(client:GetCharacter()) >= self.accessLevel) then
            if(PLUGIN:IsMetropolice(target)) then
                local notification = cpSystem.config.notification;
                notification.text = "Your new id number is:";
                notification.additional = string.format("'ID - %s'", text)

                Notify:SendMessage(target:GetPlayer(), notification);
                client:Notify(string.format("You have set the cp id of %s to %s.", target:GetName(), text));
                target:SetData("cpID", text);
                PLUGIN:UpdateName(target);
            else
                client:Notify(string.format("That character is not a part of the '%s' faction.", target:GetFaction()));
            end;
        else
            client:Notify(string.format("This command requires an access level of %s. Your access level is %s.", self.accessLevel, PLUGIN:GetAccessLevel(client:GetCharacter())));
        end;
	end;
})