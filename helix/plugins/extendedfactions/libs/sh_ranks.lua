--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

ix.ranks = {}
ix.ranks.stored = {}

-- Loads all the ranks from the plugins and assigns meta and puts them in storage.
function ix.ranks.LoadFromDir(directory)
	for _, v in ipairs(file.Find(directory.."/sh_*.lua", "LUA")) do
		local niceName = (v:sub(4, -5)):lower()

		RANK = setmetatable({uniqueID = niceName}, ix.meta.rank)

		ix.util.Include(directory.."/"..v, "shared")

		if(!ix.ranks.stored[RANK.faction]) then
			ix.ranks.stored[RANK.faction] = {}
		end

		table.insert(ix.ranks.stored[RANK.faction], RANK)
		RANK = nil
	end
end

-- Checks all the factions and returns the rank object according to the uniqueID
function ix.ranks.Get(uniqueID)
	if(!uniqueID) then
		return nil
	end
	
	for _, faction in pairs(ix.ranks.stored) do
		for _, v in pairs(faction) do
			if(v.uniqueID == uniqueID:lower()) then
				return v
			end
		end
	end

	return nil
end

-- Called when the default rank of a faction is required.
function ix.ranks.GetDefaultRank(faction)
	local ranks = ix.ranks.stored[faction]

	if(ranks) then
		for k, v in pairs(ranks) do
			if(v.isDefault) then
				return v.uniqueID
			end
		end

		-- Can't find any default ranks, return the first in the array.
		return ranks[1].uniqueID
	end

	return nil
end

-- Checks if a rank has a permission.
function ix.ranks.HasPermission(uniqueID, perm)
	local rank = ix.ranks.Get(uniqueID:lower())

	if(rank) then
		for k, v in pairs(rank.permissions) do 
			if(v == perm) then
				return true
			end
		end
	end

	return false
end

function ix.ranks.CanModify(client, target)
	if(character:GetRank().order >= target:GetRank().order) then
		return true
	end

	return false
end

-- Checks if a client can promote their target
function ix.ranks.CanPromote(character, target)
	local rank = target:GetRank()

	if(character:HasOverride() or target:GetFaction() == character:GetFaction()) then
		if(character:GetRank().order > target:GetRank().order or character:HasOverride()) then
			if(rank) then
				if(ix.ranks.NextRank(rank)) then
					return true
				else
					return false, "Your target already is the maximum rank!"
				end
			else
				return false, "Internal error! Target has an invalid rank not recognized by the script!"
			end
		else
			return false, "You cant promote to a rank higher than you!"
		end
	else
		return false, "You aren't the same faction as the target!"
	end
end

-- Checks if a client can demote their target.
function ix.ranks.CanDemote(character, target)
	local rank = target:GetRank()

	if(character:HasOverride() or target:GetFaction() == character:GetFaction()) then
		if(character:GetRank().order >= target:GetRank().order or character:HasOverride()) then
			if(rank) then
				if(ix.ranks.PreviousRank(rank)) then
					return true
				else
					return false, "Your target already is the lowest rank!"
				end
			else
				return false, "Internal error! Target has an invalid rank not recognized by the script!"
			end
		else
			return false, "That target is a higher rank than you!"
		end
	else
		return false, "You aren't the same faction as the target!"
	end
end

-- Returns the next rank when given a rank object
function ix.ranks.NextRank(rank)
	local ranks = ix.ranks.GetFactionRanks(rank.faction)

	for k, v in pairs(ranks) do
		if(v.order == rank.order-1) then
			return v
		end
	end

	return nil
end

-- Returns the previous rank when given a rank object
function ix.ranks.PreviousRank(rank)
	local ranks = ix.ranks.GetFactionRanks(rank.faction)

	for k, v in pairs(ranks) do
		if(v.order == rank.order+1) then
			return v
		end
	end

	return nil
end

-- Returns the list of ranks in a faction
function ix.ranks.GetFactionRanks(faction)
	if(ix.ranks.stored[faction] and ix.ranks.stored[faction][1]) then
		return ix.ranks.stored[faction]
	end

	return nil
end

-- Adds all the ranks from all the different plugins.
hook.Add("DoPluginIncludes", "ixRankIncludes", function(path)
	ix.ranks.LoadFromDir(path.."/ranks")
end)
