netstream.Hook("ViewDataUpdate", function(client, target, text, combinePoints)
	if (IsValid(target) and client:GetCharacter() and target:GetCharacter()) then
		local data = {
			text = text,
			editor = client:GetCharacter():GetName(),
			points = combinePoints
		}

		target:GetCharacter():SetData("combineData", data)
		Schema:AddCombineDisplayMessage("@cViewDataFiller", nil, client)
	end
end)
