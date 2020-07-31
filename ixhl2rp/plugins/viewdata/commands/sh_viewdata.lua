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
		if (!hook.Run("CanPlayerViewData", client, target:GetPlayer())) then
			return "@cantViewData"
		end
		
		local data = target:GetData("record", {})
		local cid = target:GetData("cid", 00000)

		netstream.Start(client, "ixViewData", target:GetPlayer(), cid, data)
	end;
})