--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ix.command.Add("AdminSpawnMenu", {
    adminOnly = true,
	OnRun = function(self, client)
		net.Start("adminSpawnMenu")
		net.Send(client)
	end
})