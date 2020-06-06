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


local PLUGIN = PLUGIN

netstream.Hook("ViewBook", function(data)
	local entity = data;
	
	if (IsValid(entity)) then

		local id = entity:GetID();

		if (id != 0) then
			local itemTable = ix.item.instances[id];
			
			if (itemTable and itemTable.bookInformation) then
				if (IsValid(PLUGIN.bookPanel)) then
					PLUGIN.bookPanel:Close();
					PLUGIN.bookPanel:Remove();
				end;
				
				PLUGIN.bookPanel = vgui.Create("ixViewBook");
				PLUGIN.bookPanel:SetEntity(entity);
				PLUGIN.bookPanel:Populate(itemTable);
				PLUGIN.bookPanel:MakePopup();
			end;
		end;
	end;
end);