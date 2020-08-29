--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
    without permission of its author (zacharyenriquee@gmail.com).
    
    This content is only intended to be used on the TERRANOVA
    Half-Life 2 Roleplay server. Please respect the developers.
--]]

local PLUGIN = PLUGIN;

ix.station = {}
ix.station.stored = {}

-- Called when we are adding a new recipe.
function ix.station.LoadFromDir(directory)
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

        PLUGIN.craft.stations[niceName] = STATION
        STATION = nil
	end
end

-- Returns the recipe object
function ix.station.Get(uniqueID)
	if(ix.station.stored[uniqueID]) then
		return ix.station.stored[uniqueID]
	end

	return nil
end