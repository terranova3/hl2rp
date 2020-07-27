--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN;

ix.traits = {}
ix.traits.stored = {}

function ix.traits.LoadFromDir(directory)
	for _, v in ipairs(file.Find(directory.."/sh_*.lua", "LUA")) do
		local niceName = v:sub(4, -5)
		
		TRAIT = setmetatable({uniqueID = niceName}, ix.meta.trait)

		ix.util.Include(directory.."/"..v, "shared")
		ix.traits.stored[niceName] = TRAIT
		ix.traits.stored[niceName]:Register()

		TRAIT = nil
	end
end

function ix.traits.FindByName(trait)
	trait = trait:lower()
	local uniqueID

	for k, v in pairs(ix.traits.stored) do
		if (trait:find(v.name:lower())) then
			uniqueID = k

			break
		end
	end

	return uniqueID
end

function ix.traits.Get(uniqueID)
	return ix.traits.stored[uniqueID] or nil;
end

function ix.traits.NameToUniqueID(name)
	return string.gsub(name, " ", "_"):lower();
end

hook.Add("DoPluginIncludes", "ixTraits", function(path, pluginTable)
	if (!PLUGIN.paths) then
		PLUGIN.paths = {}
	end

	table.insert(PLUGIN.paths, path)
end)