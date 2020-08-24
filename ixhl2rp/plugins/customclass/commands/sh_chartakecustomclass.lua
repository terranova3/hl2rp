ix.command.Add("CharTakeCustomClass", {
	adminOnly = true,
	arguments = {
		ix.type.character,
		ix.type.string
	},
    OnRun = function(self, client, target, text)
        target:SetCustomClass(nil);

        client:Notify(string.format("You have taken the custom class from %s.", target:GetName(), text))
	end
})