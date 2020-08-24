--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

netstream.Hook("ixViewData", function(target, cid, data)
	if(!target) then
		return
	end
	
	-- Adds a display message for combine displaying that a record has been opened.
	Schema:AddCombineDisplayMessage("@cViewData")

	ix.gui.record = vgui.Create("ixCombineViewData")
	ix.gui.record:Build(target, cid, data)
end)