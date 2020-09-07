--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
    without permission of its author (zacharyenriquee@gmail.com).
    
    This content is only intended to be used on the TERRANOVA
    Half-Life 2 Roleplay server. Please respect the developers.
--]]

ix.command.Add("CharManageBlueprints", {
    description = "Manages a character's blueprints.",
    adminOnly = true,
    arguments = {
        ix.type.character
	},
    OnRun = function(self, client, target)
        net.Start("ixManageBlueprints")
            net.WriteInt(target:GetID(), 32)
        net.Send(client)
	end;
})
