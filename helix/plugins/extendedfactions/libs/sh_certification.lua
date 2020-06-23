--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

local PLUGIN = PLUGIN;

ix.certs = ix.certs or {}
ix.certs.stored = ix.certs.stored or {}

function ix.certs.LoadFromDir(directory)
	for _, v in ipairs(file.Find(directory.."/sh_*.lua", "LUA")) do
		local niceName = v:sub(4, -5)
		
		CERT = setmetatable({uniqueID = niceName}, ix.meta.cert)

		ix.util.Include(directory.."/"..v, "shared")
		ix.certs.stored[niceName] = CERT

		CERT = nil
	end
end

function ix.certs.FindByName(cert)
	cert = cert:lower()
	local uniqueID

	for k, v in pairs(ix.certs.stored) do
		if (cert:find(v.name:lower())) then
			uniqueID = k

			break
		end
	end

	return uniqueID
end

function ix.certs.Get(uniqueID)
	return ix.certs.stored[uniqueID] or nil;
end

function ix.certs.NameToUniqueID(name)
	return string.gsub(name, " ", "_"):lower();
end

function ix.certs.GetCertsAsString(character)
	local certs = ""

	for k, v in pairs(character:GetData("certs", {})) do
		certs = certs .. " " ..  v
	end

	return certs
end

hook.Add("DoPluginIncludes", "ixRankIncludes", function(path)
	ix.certs.LoadFromDir(path.."/certs")
end)