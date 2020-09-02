--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
    without permission of its author (zacharyenriquee@gmail.com).
    
    This content is only intended to be used on the TERRANOVA
    Half-Life 2 Roleplay server. Please respect the developers.
--]]

local PLUGIN = PLUGIN;

ix.stations = {}
ix.stations.stored = {}

-- Called when we are adding a new recipe.
function ix.stations.LoadFromDir(directory)
	for _, v in ipairs(file.Find(directory.."/sh_*.lua", "LUA")) do
		local niceName = v:sub(4, -5)
        STATION = setmetatable({uniqueID = niceName}, PLUGIN.meta.station)
        
        ix.util.Include(directory.."/"..v, "shared")

        if (!scripted_ents.Get("ix_station_"..niceName)) then
            local STATION_ENT = scripted_ents.Get("ix_station")
            STATION_ENT.PrintName = STATION.name
            STATION_ENT.uniqueID = niceName
            STATION_ENT.Spawnable = true
            STATION_ENT.AdminOnly = true
            scripted_ents.Register(STATION_ENT, "ix_station_"..niceName)
        end

        ix.stations.stored[niceName] = STATION
        STATION = nil
	end
end

-- Returns the recipe object
function ix.stations.Get(uniqueID)
	if(ix.stations.stored[uniqueID]) then
		return ix.stations.stored[uniqueID]
	end

	return nil
end