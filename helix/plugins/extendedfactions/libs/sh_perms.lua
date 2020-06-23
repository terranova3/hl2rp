--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ix.perms = {}
ix.perms.stored = {}

function ix.perms.Register(name)
    table.insert(ix.perms.stored, name)
end

function ix.perms.LoadFromDir(directory)
	for _, v in ipairs(file.Find(directory.."/sh_*.lua", "LUA")) do
		ix.util.Include(directory.."/"..v, "shared")
	end
end

hook.Add("DoPluginIncludes", "ixRankIncludes", function(path)
	ix.perms.LoadFromDir(path.."/perms")
end)