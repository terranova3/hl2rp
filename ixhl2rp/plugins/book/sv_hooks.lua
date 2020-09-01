
resource.AddFile("materials/terranova/ui/books/blankbook.png")

netstream.Hook("ixSaveBookChanges", function(client, itemID, text)

	local character = client:GetCharacter()
	local item = ix.item.instances[itemID]

	-- we don't check for entity since data can be changed in the player's inventory
	if (character and item and item.base == "base_book") then
		local owner = item:GetData("owner", 0)
		if (owner == 0 or owner == character:GetID()) then
			item:SetText(text, character)
		end
	end
end)
