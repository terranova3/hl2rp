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
		shouldShow = shouldShow or true,
		callback = callback,
		name = name,
		icon = icon
	};
end;

ix.quickmenu:AddCallback("Edit Physical Description", "icon16/book_edit.png", function()
	ix.command.Send("CharPhysDesc")
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
end, LocalPlayer():IsAdmin());
