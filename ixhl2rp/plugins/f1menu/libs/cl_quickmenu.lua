--[[
    Copyright © 2020 Cloud Sixteen

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]


local ix = ix;

ix.quickmenu = {}
ix.quickmenu.stored = {};

-- A function to add a quick menu callback.
function ix.quickmenu:AddCallback(name, icon, callback, shouldShow)
	self.stored[#ix.quickmenu.stored+1] = {
		shouldShow = shouldShow,
		callback = callback,
		name = name,
		icon = icon
	};
end;

function ix.quickmenu.IsAdmin()
	if(LocalPlayer() and LocalPlayer():GetCharacter() and LocalPlayer():IsAdmin()) then
		return true
	end

	return false
end

ix.quickmenu:AddCallback("Edit Physical Description", "icon16/note_edit.png", function()
	ix.command.Send("CharPhysDesc")
end);

ix.quickmenu:AddCallback("Edit Detailed Description", "icon16/book_edit.png", function()
	local Frame = vgui.Create("DFrame")
	Frame:Center()
	Frame:SetPos(Frame:GetPos() - 150, 250, 0)
	Frame:SetSize(350, 500)
	Frame:SetTitle("Edit Detailed Description")
	Frame:MakePopup()

	local List = vgui.Create("DListView", Frame)
	List:Dock( FILL )
	List:DockMargin( 0, 0, 0, 5 )
	List:SetMultiSelect(false)
	
	local textEntry = vgui.Create("DTextEntry", List)
	textEntry:Dock( FILL )
	textEntry:DockMargin( 0, 0, 0, 0 )
	textEntry:SetMultiline(true)
	textEntry:SetVerticalScrollbarEnabled(true)
	
	if (LocalPlayer():GetCharacter():GetData("textDetDescData")) then
		textEntry:SetText(LocalPlayer():GetCharacter():GetData("textDetDescData"))
	end
	
	local DButton = vgui.Create("DButton", List)
	DButton:DockMargin( 0, 0, 0, 0 )
	DButton:Dock( BOTTOM )
	DButton:SetText("Edit")
	DButton:SetTextColor(Color(0, 0, 0, 255))
	
	local textEntryURL = vgui.Create("DTextEntry", List)
	textEntryURL:Dock( BOTTOM )
	textEntryURL:DockMargin( 0, 0, 0, 0 )
	textEntryURL:SetValue("Reference Image URL")
	
	if (LocalPlayer():GetCharacter():GetData("textDetDescDataURL")) then
		textEntryURL:SetValue(LocalPlayer():GetCharacter():GetData("textDetDescDataURL"))
		textEntryURL:SetText(LocalPlayer():GetCharacter():GetData("textDetDescDataURL"))
	end
	
	DButton.DoClick = function()
		net.Start("ixEditDetailedDescriptions")
			net.WriteString(textEntryURL:GetValue())
			net.WriteString(textEntry:GetValue())
			net.WriteString(LocalPlayer():SteamName())
		net.SendToServer()
		Frame:Remove()
	end
end);

ix.quickmenu:AddCallback("Drop Tokens", "icon16/money_delete.png", function()
	local description = string.format("How many tokens do you want to drop? You have %s.", LocalPlayer():GetCharacter():GetMoney())

	Derma_StringRequest("Drop Tokens", description, 20, function(text)
		ix.command.Send("DropMoney", text)
	end, nil, "Drop", "Cancel")
end);

ix.quickmenu:AddCallback("Fall Over", "icon16/user.png", function()
	ix.command.Send("CharFallOver")
end);

ix.quickmenu:AddCallback("Spawn Items", "icon16/script.png", function()
	ix.command.Send("adminspawnmenu")
end, ix.quickmenu.IsAdmin);
