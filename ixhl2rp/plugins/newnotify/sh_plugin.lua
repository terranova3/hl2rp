--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

PLUGIN.name = "New Notify";
PLUGIN.description = "Adds a new notify for the framework.";
PLUGIN.author = "Adolphus";

-- Global table so we can access this plugin outside of itself.
Notify = {}

ix.util.Include("sv_hooks.lua")

local PLUGIN = PLUGIN

-- debug
ix.command.Add("notify", {
	adminOnly = true,
	OnRun = function(self, client)
		local data = {
			faction = "CITIZEN", 
			title = "CITIZEN!", 
			sound = "sound/terranova/ui/notification_citizen.mp3",
			text = "You have been assigned to:", 
			additional = "CUM - Apartment 3",
			titleColor = Color(255, 224, 0)
		}

		local data2 = {
			faction = "MPF", 
			title = "UNIT!", 
			sound = "sound/terranova/ui/notification_mpf.mp3",
			text = "You have been promoted to:", 
			additional = "Intention - 3",
			titleColor = Color(50, 100, 150)
		}

		Notify:SendMessage(Entity(1), data2);
	end;
})