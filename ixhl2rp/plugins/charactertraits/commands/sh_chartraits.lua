--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]
local PLUGIN = PLUGIN;

ix.command.Add("CharTraits", {
    adminOnly = true,
	arguments = {
		ix.type.character
	},
	OnRun = function(self, client, target)
		local targetClient = target:GetPlayer()
		
        netstream.Start(client, "ViewCharTraits", targetClient)
	end;
})