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
function ix.recipe.LoadFromDir(directory, category)
	for _, v in ipairs(file.Find(directory.."/sh_*.lua", "LUA")) do
		local niceName = v:sub(4, -5)
		
		RECIPE = setmetatable({uniqueID = niceName, profession = category}, PLUGIN.meta.recipe)
		
		local shouldInclude = true

		for k, v in pairs(RECIPE.results) do
			if(!ix.item.list[k]) then
				shouldInclude = false
				ErrorNoHalt(k .. "is not a valid item uniqueID in recipe " .. RECIPE.name)
				break
			end
		end

		if(shouldInclude) then
			ix.util.Include(directory.."/"..v, "shared")
			ix.recipe.stored[niceName] = RECIPE
		end

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

-- Called when we need to iterate through a recipes list and organise recipes into their categories
function ix.recipe.GetCategories(recipes)
	recipes = recipes or ix.recipe.stored

	local categories = {}

	for k, v in pairs(recipes) do
		assert(getmetatable(v) == PLUGIN.meta.recipe, "expected valid recipe")

		if(!categories[v.category]) then
			categories[v.category] = {}
			categories[v.category].recipes = {}
		end

		table.insert(categories[v.category].recipes, v)
	end

	return categories
end