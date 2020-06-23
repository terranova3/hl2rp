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
		local targetClient = target:GetPlayer()
		local cpData = cpSystem.GetCPDataAsTable(target);

		--if (!hook.Run("CanPlayerViewData", client, targetClient)) then
		--	return "@cantViewData"
		--end
		
		netstream.Start(client, "ViewData", targetClient, target:GetData("cid"), target:GetData("combineData", {}), cpData)
	end;
})