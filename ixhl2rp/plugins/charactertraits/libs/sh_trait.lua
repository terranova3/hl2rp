--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN;

ix.traits = ix.traits or {}
ix.traits.stored = ix.traits.stored or {}
ix.traits.categories = {
	["Physical"] = Color(223, 154, 72, 5),
	["Philosophy"] = Color(142, 68, 173, 5),
	["Mentality"] = Color(22, 160, 133, 5),
	["Intelligence"] = Color(41, 128, 185, 5)
}

function ix.traits.LoadFromDir(directory)
	for _, v in ipairs(file.Find(directory.."/sh_*.lua", "LUA")) do
		local niceName = v:sub(4, -5)
		
		TRAIT = setmetatable({uniqueID = niceName}, ix.meta.trait)

		ix.util.Include(directory.."/"..v, "shared")
		ix.traits.stored[niceName] = TRAIT

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

function ix.traits.GetAlpha(uniqueID)
	local trait = ix.traits.stored[uniqueID]
	
	if(trait.negative) then
		return 5
	else
		return 10
	end
end

function ix.traits.CallHook(hook, character)
	local client = character:GetPlayer();
	
	for _, v in pairs(character:GetData("traits", {})) do
		local trait = ix.traits.Get(v);

		if(IsValid(trait) and trait.hooks[hook]) then
			trait.hooks[hook](client, character);
		end
	end
end

hook.Add("DoPluginIncludes", "ixTraits", function(path, pluginTable)
	if (!PLUGIN.paths) then
		PLUGIN.paths = {}
	end

	table.insert(PLUGIN.paths, path)
end)
