--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

ix.certs = {}
ix.certs.stored = {}

function ix.certs.LoadFromDir(directory)
	for _, v in ipairs(file.Find(directory.."/sh_*.lua", "LUA")) do
		local niceName = v:sub(4, -5)
		
		CERT = setmetatable({uniqueID = niceName}, ix.meta.cert)

		ix.util.Include(directory.."/"..v, "shared")

		if(!ix.certs.stored[CERT.faction]) then
			ix.certs.stored[CERT.faction] = {}
		end

		table.insert(ix.certs.stored[CERT.faction], CERT)

		CERT = nil
	end
end

function ix.certs.Get(uniqueID)
	for _, faction in pairs(ix.certs.stored) do
		for _, v in pairs(faction) do
			if(v.uniqueID == uniqueID) then
				return v
			end
		end
	end

	return nil
end

function ix.certs.GetCertsAsString(character)
	local certs = ""

	for k, v in pairs(character:GetData("certs", {})) do
		certs = certs .. " " ..  v
	end

	return certs
end

-- Checks if a client can demote their target.
function ix.certs.CanChangeCert(character, target, cert)
	if(character:HasOverride() or target:GetFaction() == character:GetFaction()) then
		if(character:GetRank().order >= target:GetRank().order or character:HasOverride()) then
			if(!cert or cert.faction == target:GetFaction()) then
				return true
			else
				return false, "That certification cannot be obtained by the target's faction."
			end
		else
			return false, "That target is a higher rank than you!"
		end
	else
		return false, "You aren't the same faction as the target!"
	end
end

hook.Add("DoPluginIncludes", "ixCertIncludes", function(path)
	ix.certs.LoadFromDir(path.."/certs")
end)