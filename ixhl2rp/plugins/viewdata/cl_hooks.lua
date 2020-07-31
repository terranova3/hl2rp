--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

local PLUGIN = PLUGIN;

-- Called when viewdata panel has been requested.
net.Receive("ixViewdataInitiate", function()
	local character = net.ReadTable()

	-- Check if the entity still exists.
	if(!character) then
		return
	end

	-- Adds a display message for combine displaying that a record has been opened.
	Schema:AddCombineDisplayMessage("@cViewData")

	ix.gui.record = vgui.Create("ixCombineViewData")
	ix.gui.record:Build(character)
end)