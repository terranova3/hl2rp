--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]
local PLUGIN = PLUGIN;

ix.command.Add("ViewData", {
	arguments = {
		ix.type.character
	},
	OnRun = function(self, client, target)
		--if (!hook.Run("CanPlayerViewData", client, targetClient)) then
		--	return "@cantViewData"
		--end
		
		net.Start("ixViewdataInitiate")
			net.WriteInt(target.id, 16)
		net.Send(client)
	end;
})