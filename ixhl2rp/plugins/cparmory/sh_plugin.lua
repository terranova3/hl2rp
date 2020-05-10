--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

PLUGIN.name = "Civil Protection Armory";
PLUGIN.description = "Adds a civil protection armory with logging system to detect flow of items.";
PLUGIN.author = "Adolphus";
PLUGIN.maxLength = 512;
PLUGIN.armoryLog = PLUGIN.armoryLog or {};

ix.util.Include("sv_hooks.lua")

local PLUGIN = PLUGIN;

function PLUGIN:GetArmoryCount()
	local count = 0

	for _, v in pairs(PLUGIN.armoryLog) do
		count = count + 1;
	end

	return count;
end

function PLUGIN:AddArmoryLog(data)	
	local count = PLUGIN:GetArmoryCount() + 1;
	PLUGIN.armoryLog[count] = data;

	PrintTable(PLUGIN.armoryLog);
end;
