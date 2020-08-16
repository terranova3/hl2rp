--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
    without permission of its author (zacharyenriquee@gmail.com).
    
    This content is only intended to be used on the TERRANOVA
    Half-Life 2 Roleplay server. Please respect the developers.
--]]

local PLUGIN = PLUGIN;

ix.recipe = {}
ix.recipe.stored = {}

-- Called when we are adding a new recipe.
function ix.recipe.LoadFromDir(directory)
	for _, v in ipairs(file.Find(directory.."/sh_*.lua", "LUA")) do
		local niceName = v:sub(4, -5)
		
		RECIPE = setmetatable({uniqueID = niceName}, PLUGIN.meta.recipe)

		ix.util.Include(directory.."/"..v, "shared")
		ix.recipe.stored[niceName] = RECIPE

		RECIPE = nil
	end
end

-- Returns the recipe object
function ix.recipe.Get(uniqueID)
	if(ix.recipe.stored[uniqueID]) then
		return ix.recipe.stored[uniqueID]
	end

	return nil
end