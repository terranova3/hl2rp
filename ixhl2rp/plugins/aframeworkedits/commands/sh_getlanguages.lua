--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

ix.command.Add("GetLanguages", {
    description = "Returns a character's languages.",
    adminOnly = true,
    arguments = {
		ix.type.character
	},
    OnRun = function(self, client, target)
        local languages = ix.util.TableToString(target:GetData("languages", {}))

        if(languages == "") then
            client:Notify(string.format("%s has no additional languages.", target:GetName()))
        else
            client:Notify(string.format("%s has the following languages: %s", target:GetName(), languages))
        end
	end;
})