--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]
local PLUGIN = PLUGIN;

local COMMAND = {}
COMMAND.description = ""
COMMAND.adminOnly = true
COMMAND.arguments = { ix.type.character, ix.type.text }
COMMAND.syntax = "<string name> <string rank>"

function COMMAND:OnRun(target)
	target:SetData("cpRank", )
end

ix.command.Add("CharSetCPRank", COMMAND)