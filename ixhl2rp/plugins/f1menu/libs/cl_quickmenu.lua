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
ix.quickmenu.stored = ix.quickmenu.stored or {};
ix.quickmenu.categories = ix.quickmenu.categories or {};

-- A function to add a quick menu callback.
function ix.quickmenu:AddCallback(name, category, GetInfo, OnCreateMenu)
	if (category) then
		if (!self.categories[category]) then
			self.categories[category] = {};
		end;
		
		self.categories[category][name] = {
			OnCreateMenu = OnCreateMenu,
			GetInfo = GetInfo,
			name = name
		};
	else
		self.stored[name] = {
			OnCreateMenu = OnCreateMenu,
			GetInfo = GetInfo,
			name = name
		};
	end;
	
	return name;
end;

-- A function to add a command quick menu callback.
function ix.quickmenu:AddCommand(name, category, command, options)
	return self:AddCallback(name, category, function()
		local commandTable = ix.command.FindByID(command);
		
		if (commandTable) then
			return {
				toolTip = commandTable.tip,
				Callback = function(option)
					--Clockwork.kernel:RunCommand(command, option);
				end,
				options = options
			};
		else
			return false;
		end;
	end);
end;

ix.quickmenu:AddCallback("Fall Over", nil, function()
	local commandTable = ix.command.FindByID("CharFallOver");
	
	if (commandTable) then
		return {
			toolTip = commandTable.tip,
			Callback = function(option)
				--Clockwork.kernel:RunCommand("CharFallOver");
			end
		};
	else
		return false;
	end;
end);

ix.quickmenu:AddCallback("Description", nil, function()
	local commandTable = ix.command.FindByID("CharPhysDesc");
	
	if (commandTable) then
		return {
			toolTip = commandTable.tip,
			Callback = function(option)
				--Clockwork.kernel:RunCommand("CharPhysDesc");
			end
		};
	else
		return false;
	end;
end);