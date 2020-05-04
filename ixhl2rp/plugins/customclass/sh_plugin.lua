--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

PLUGIN.name = "Custom Class";
PLUGIN.description = "Adds custom class functionality for the scoreboard.";
PLUGIN.author = "Adolphus";
PLUGIN.maxLength = 512;

function PLUGIN:IncludeDirectory(name)
	local directory = PLUGIN.folder .. "/" .. name .. "/";
	for _, v in ipairs(file.Find(directory.."*.lua", "LUA")) do
		ix.util.Include(directory..v)
	end
end;

PLUGIN:IncludeDirectory("commands")


