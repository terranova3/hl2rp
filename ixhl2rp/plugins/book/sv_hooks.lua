
resource.AddFile("materials/terranova/ui/books/blankbook.png")

-- If markerOnly is true, then only change marker position, not text.
netstream.Hook("ixSaveBookChanges", function(client, itemID, text, markerOnly, markerPos)

	markerOnly = markerOnly and markerOnly or false
	markerPos = markerPos and markerPos or "none"

	local character = client:GetCharacter()
	local item = ix.item.instances[itemID]
 
	-- we don't check for entity since data can be changed in the player's inventory
	if (character and item and item.base == "base_book") then

		if markerOnly then
			local numberMarkerPos = tonumber(markerPos)
			if numberMarkerPos ~= nil then 
				item:SetMarker(numberMarkerPos)
				return
			end
		end

		local owner = item:GetData("owner", 0)
		if (owner == 0 or owner == character:GetID()) then
			item:SetText(text, character)
		end
	end
end)



