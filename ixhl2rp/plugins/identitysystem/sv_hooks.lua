netstream.Hook("ViewDataUpdate", function(client, data)
	local target = data.target

	if (IsValid(target) and client:GetCharacter() and target:GetCharacter()) then
		target:GetCharacter():SetData("combineData", data)
		Schema:AddCombineDisplayMessage("@cViewDataFiller", nil, client)
	end
end)
