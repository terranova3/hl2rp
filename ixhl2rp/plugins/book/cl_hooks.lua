
netstream.Hook("ixViewBook", function(itemID, textArray, isEditing)
	isEditing = tobool(isEditing)
	local panel = vgui.Create("ixBook")
	
	panel.textArray = textArray
	panel:SetItemID(itemID)
	panel:SetEditMode(isEditing)
	panel:UpdatePages()
end)
