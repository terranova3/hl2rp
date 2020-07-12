--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN

netstream.Hook("EditApplication", function(data)
	if(IsValid(ix.gui.menu)) then
		ix.gui.menu:Remove()
	end

	if (IsValid(PLUGIN.bookPanel)) then
		PLUGIN.businessApplication:Close()
		PLUGIN.businessApplication:Remove()
	end

	PLUGIN.businessApplication = vgui.Create("ixBusinessApplication")
	PLUGIN.businessApplication:Build(data[1], data[2])
end)

