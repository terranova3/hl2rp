--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

-- Called when creating a new instance of an array with a metatable.
function ix.util.NewInstance(obj, seen)
    if type(obj) ~= 'table' then return obj end
    if seen and seen[obj] then return seen[obj] end
    local s = seen or {}
    local res = setmetatable({}, getmetatable(obj))
    s[obj] = res
    for k, v in pairs(obj) do res[ix.util.NewInstance(k, s)] = ix.util.NewInstance(v, s) end
    return res
end

function ix.util.Chance(chance)
    local rand = math.random(0, 100)

    if(rand <= chance) then
        return true
    end

    return false
end