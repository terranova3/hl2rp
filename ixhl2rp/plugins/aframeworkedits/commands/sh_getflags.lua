--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

ix.command.Add("GetFlags", {
    description = "Returns a character's flags.",
    adminOnly = true,
    arguments = {
		ix.type.character
	},
    OnRun = function(self, client, target)
        local flags = target:GetFlags()

        if(flags == "") then
            client:Notify(string.format("%s has no flags.", target:GetName()))
        else
            client:Notify(string.format("%s has the following flags: %s", target:GetName(), flags))
        end
	end;
})