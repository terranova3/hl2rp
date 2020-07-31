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
		
		net.Start("ixViewdataInitiate")
			net.WriteInt(target.id, 16) -- We can actually save on data by just sending the character id. The client can index it from char loaded table.
		net.Send(client)
	end;
})