--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ix.command.Add("CharAddLanguage", {
	adminOnly = true,
	arguments = {
		ix.type.character,
		ix.type.string
	},
	OnRun = function(self, client, target, text)
		local result, error = target:AddLanguage(text)

		if(result) then
			client:Notify(string.format("You added the language %s to %s.", text, target:GetName()))
			target:GetPlayer():Notify(string.format("You have been given the %s language.", text))
		elseif(error) then
			client:Notify(error)
		end
	end
})