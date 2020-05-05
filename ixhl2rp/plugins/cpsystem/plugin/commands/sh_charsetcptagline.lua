--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

local PLUGIN = PLUGIN

ix.command.Add("CharSetCPTagline", {
    description = "Sets the tagline of a civil protection unit.",
	adminOnly = true, -- TODO: Access based on rank, not admin.
	arguments = {
		ix.type.character,
		ix.type.string
	},
    OnRun = function(self, client, target, text)
        if(PLUGIN:IsMetropolice(target)) then
            if(PLUGIN:TaglineExists(text)) then
                client:Notify(string.format("You have set the tagline of %s to %s.", target:GetName(), text));
                target:SetData("cpTagline", text);
                PLUGIN:UpdateName(target);
            else
                client:Notify(string.format("The tagline '%s' does not exist.", text));
            end;
        else
            client:Notify(string.format("That character is not a part of the '%s' faction.", target:GetFaction()));
        end;
	end;
})