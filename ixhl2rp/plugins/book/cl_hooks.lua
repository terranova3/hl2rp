
netstream.Hook("ixViewBook", function(itemID, textArray, isEditing, markerPos)
	isEditing = tobool(isEditing)
	local panel = vgui.Create("ixBook")
	
	local marker = markerPos % 2 == 1 and markerPos or markerPos - 1

	panel.marker = marker
	panel.textArray = textArray
	panel:SetItemID(itemID)
	panel:SetEditMode(isEditing)
	panel:UpdatePages()
end)
