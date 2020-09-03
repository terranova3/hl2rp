--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ix.command.Add("CharRemoveLanguage", {
	adminOnly = true,
	arguments = {
		ix.type.character,
		ix.type.string
	},
	OnRun = function(self, client, target, text)
		local result, error = target:RemoveLanguage(text)
		
		if(result) then
			client:Notify(string.format("You have removed the language %s from %s.", text, target:GetName()))
		elseif(error) then
			client:Notify(error)
		end
	end
})