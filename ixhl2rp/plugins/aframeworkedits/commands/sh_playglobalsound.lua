--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

ix.command.Add("PlaySoundGlobal", {
    description = "Plays a sound to all players.",
    adminOnly = true,
    arguments = {
		ix.type.text
	},
    OnRun = function(self, client, sound)
        for _, target in pairs(player.GetAll()) do
            netstream.Start(target, "ixPlaySound", sound)
        end

        client:Notify("Playing sound '" .. sound .. "' to all players.")
	end
})