--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN

ix.command.Add("CharRemoveLanguage", {
	adminOnly = true,
	arguments = {
		ix.type.character,
		ix.type.string
	},
	OnRun = function(self, client, target, text)
		local result = target:RemoveLanguage(L(text))
		
		if(result) then
			client:Notify(string.format("You have removed the language %s from %s.", L(text), target:GetName()))
		elseif(error) then
			client:Notify(error)
		end
	end
})