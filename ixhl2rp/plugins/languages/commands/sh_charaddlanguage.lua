--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN

ix.command.Add("CharAddLanguage", {
	adminOnly = true,
	arguments = {
		ix.type.character,
		ix.type.string
	},
	OnRun = function(self, client, target, text)
		local result, error = target:AddLanguage(L(text))

		if(result) then
			client:Notify(string.format("You added the language %s to %s.", L(text), target:GetName()))
		elseif(error) then
			client:Notify(error)
		end
	end
})