--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN

net.Receive("ixBusinessApplicationEdit", function()
	local id = net.ReadInt(16)
	local editMode = net.ReadBool()

	if(IsValid(ix.gui.menu)) then
		ix.gui.menu:Remove()
	end

	if (IsValid(PLUGIN.bookPanel)) then
		PLUGIN.businessApplication:Close()
		PLUGIN.businessApplication:Remove()
	end

	PLUGIN.businessApplication = vgui.Create("ixBusinessApplication")
	PLUGIN.businessApplication:Build(id, editMode)
end)
