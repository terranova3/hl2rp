--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
    without permission of its author (zacharyenriquee@gmail.com).
    
    This content is only intended to be used on the TERRANOVA
    Half-Life 2 Roleplay server. Please respect the developers.
--]]

local PLUGIN = PLUGIN;

ix.professions = {}
ix.professions.stored = {}

function ix.professions.LoadFromDir(directory)
	for _, v in ipairs(file.Find(directory.."/sh_*.lua", "LUA")) do
		local niceName = v:sub(4, -5)
		
		PROFESSION = setmetatable({uniqueID = niceName}, ix.meta.profession)

		ix.util.Include(directory.."/"..v, "shared")
		ix.professions.stored[niceName] = PROFESSION
		ix.professions.stored[niceName]:Register()

		PROFESSION = nil
	end
end